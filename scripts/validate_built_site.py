"""Validate required Pages output and browser resource security."""
import argparse
from html.parser import HTMLParser
from pathlib import Path
import re
from urllib.parse import urlsplit

REQUIRED = ('assets/js/search-data.js', 'assets/img/kicad_main_board.png',
            'assets/img/og-kicad-main-board.png', '.well-known/security.txt')


def validate_css(text):
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.S)
    text = re.sub(r'\\([0-9a-fA-F]{1,6})\s?',
                  lambda m: chr(int(m[1], 16)) if 0 < int(m[1], 16) <= 0x10ffff else '\ufffd', text)
    text = re.sub(r'\\([^\n\r\f])', r'\1', text)
    failures = []
    for match in re.finditer(r'url\(\s*[\'\"]?([^\s)\'\"]+)', text, re.I):
        if match[1].lower().startswith(('http:', '//')):
            failures.append('insecure CSS resource: ' + match[1])
    for match in re.finditer(r'@import\s+(?:url\(\s*)?[\'\"]?([^\s;\'\")]+)', text, re.I):
        if urlsplit(match[1]).scheme or match[1].startswith('//'):
            failures.append('external CSS import cannot carry SRI: ' + match[1])
    return failures


class PageParser(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.failures = []
        self.in_style = False

    def handle_starttag(self, tag, attributes):
        names = [name for name, _ in attributes]
        if len(names) != len(set(names)):
            self.failures.append('duplicate HTML attributes')
        attrs = dict(attributes)
        if tag == 'base':
            self.failures.append('document base overrides are forbidden')
        if tag == 'style':
            self.in_style = True
        if attrs.get('style'):
            self.failures.extend(validate_css(attrs['style']))
        if attrs.get('target', '').lower() == '_blank' and 'noopener' not in attrs.get('rel', '').lower().split():
            self.failures.append('new-tab link lacks noopener')
        resource = tag in {'script', 'img', 'iframe', 'source', 'video', 'audio', 'embed', 'object', 'input', 'image', 'use', 'feimage'}
        urls = []
        if resource:
            urls.extend(attrs.get(key, '') for key in ('src', 'poster', 'data', 'href', 'xlink:href'))
            urls.extend(part.strip().split()[0] for part in attrs.get('srcset', '').split(',') if part.strip())
        if tag == 'link':
            urls.append(attrs.get('href', ''))
        for url in urls:
            if url.strip().lower().startswith(('http:', '//')):
                self.failures.append('insecure active resource: ' + url)
        executable = tag == 'script' or (tag == 'link' and 'stylesheet' in attrs.get('rel', '').lower().split())
        url = (attrs.get('src') or attrs.get('href') or attrs.get('xlink:href') or '') if tag == 'script' else attrs.get('href', '')
        parsed = urlsplit(url)
        if executable and (parsed.netloc or parsed.scheme):
            if parsed.scheme != 'https' or not parsed.netloc:
                self.failures.append('external executable resource must use HTTPS: ' + url)
            if not re.search(r'(?<!\d)\d+\.\d+\.\d+(?!\d)', parsed.path):
                self.failures.append('external executable resource lacks exact version: ' + url)
            if not re.fullmatch(r'sha384-[A-Za-z0-9+/]{64}', attrs.get('integrity', '')):
                self.failures.append('external executable resource lacks SHA-384 integrity: ' + url)
            if attrs.get('crossorigin') != 'anonymous':
                self.failures.append('external executable resource lacks anonymous crossorigin: ' + url)

    handle_startendtag = handle_starttag

    def handle_endtag(self, tag):
        if tag == 'style':
            self.in_style = False

    def handle_data(self, data):
        if self.in_style:
            self.failures.extend(validate_css(data))


def validate_site(directory: str | Path) -> list[str]:
    root = Path(directory)
    failures = []
    if root.is_symlink() or not root.is_dir():
        return ['output must be an existing directory, not a symlink']
    for name in REQUIRED:
        path = root / name
        if path.is_symlink() or not path.is_file():
            failures.append('missing required public artifact: ' + name)
    for path in sorted(p for p in root.rglob('*') if p.suffix.lower() in {'.html', '.css', '.svg'}):
        if path.is_symlink() or not path.resolve().is_relative_to(root.resolve()):
            failures.append('unsafe HTML path: ' + path.relative_to(root).as_posix())
            continue
        try:
            content = path.read_text(encoding='utf-8')
            if path.suffix.lower() == '.css':
                found = validate_css(content)
            else:
                parser = PageParser()
                parser.feed(content)
                found = parser.failures
            failures.extend(path.relative_to(root).as_posix() + ': ' + item for item in found)
        except (OSError, UnicodeError, ValueError):
            failures.append('unreadable or malformed HTML: ' + path.relative_to(root).as_posix())
    return sorted(set(failures))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('directory')
    failures = validate_site(parser.parse_args().directory)
    for failure in failures:
        print(failure)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
