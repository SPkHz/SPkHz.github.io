import io
from pathlib import Path
import subprocess
import tarfile
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class PagesArchive(unittest.TestCase):
    def extract(self, entries):
        with tempfile.TemporaryDirectory() as temp:
            archive = Path(temp) / 'artifact.tar'
            with tarfile.open(archive, 'w') as stream:
                for name, kind, content in entries:
                    entry = tarfile.TarInfo(name)
                    entry.type = kind
                    if kind == tarfile.REGTYPE:
                        data = content.encode()
                        entry.size = len(data)
                        stream.addfile(entry, io.BytesIO(data))
                    else:
                        entry.linkname = content
                        stream.addfile(entry)
            destination = Path(temp) / 'site'
            result = subprocess.run(['python3', '-B', str(ROOT / 'scripts/extract_pages_artifact.py'),
                                     str(archive), str(destination)], capture_output=True, text=True)
            files = {p.relative_to(destination).as_posix(): p.read_bytes()
                     for p in destination.rglob('*') if p.is_file() and not p.is_symlink()}
            return result, files

    def test_valid_pages_archive_preserves_exact_bytes_and_hidden_contact(self):
        result, files = self.extract([
            ('./', tarfile.DIRTYPE, ''),
            ('./index.html', tarfile.REGTYPE, '<html>λ</html>\n'),
            ('./.well-known', tarfile.DIRTYPE, ''),
            ('./.well-known/security.txt', tarfile.REGTYPE, 'Contact: mailto:security@example.test\n'),
        ])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(files, {'index.html': '<html>λ</html>\n'.encode(),
                                 '.well-known/security.txt': b'Contact: mailto:security@example.test\n'})

    def test_unsafe_archive_members_fail_before_any_extraction(self):
        bad = [('.. /escape', tarfile.SYMTYPE, '/tmp'),
               ('../../escape', tarfile.REGTYPE, 'unsafe'),
               ('/absolute', tarfile.REGTYPE, 'unsafe'),
               ('link', tarfile.SYMTYPE, 'index.html'),
               ('hardlink', tarfile.LNKTYPE, 'index.html'),
               ('pipe', tarfile.FIFOTYPE, ''),
               ('device', tarfile.CHRTYPE, '')]
        for entry in bad:
            with self.subTest(entry=entry):
                result, files = self.extract([('index.html', tarfile.REGTYPE, 'safe'), entry])
                self.assertNotEqual(result.returncode, 0)
                self.assertIn('Unsafe', result.stderr)
                self.assertEqual(files, {})

    def test_duplicate_and_file_directory_collisions_fail(self):
        for entries in ([('x', tarfile.REGTYPE, 'one'), ('./x', tarfile.REGTYPE, 'two')],
                        [('x', tarfile.REGTYPE, 'one'), ('x/y', tarfile.REGTYPE, 'two')]):
            result, files = self.extract(entries)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('Unsafe', result.stderr)
            self.assertEqual(files, {})
