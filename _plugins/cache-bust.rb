require 'cgi'
require 'digest'
require 'pathname'
require 'uri'

module Jekyll
  module CacheBust
    CSS_MARKER = '__SITE_CSS_SHA256__'.freeze
    LINK_TAG = /<link\b(?:[^>"']|"[^"]*"|'[^']*')*>/i
    ATTRIBUTE = /\b(rel|href)\s*=\s*(["'])(.*?)\2/i

    # Static JS/image callers retain their existing template interface.
    def bust_file_cache(file_name)
      source_path = file_name[file_name.index('assets/')..].split(/[?#]/).first
      "#{file_name}?#{Digest::MD5.file(source_path).hexdigest}"
    end

    # Sass does not exist on disk yet during Liquid rendering.
    def bust_css_cache(file_name)
      path, fragment = file_name.split('#', 2)
      separator = path.include?('?') ? '&' : '?'
      "#{path}#{separator}v=#{CSS_MARKER}#{fragment ? "##{fragment}" : ''}"
    end

    def self.finalize_site_css(site)
      root = File.realpath(site.dest)
      baseurl = site.config.fetch('baseurl', '').to_s.sub(%r{/\z}, '')
      Dir.glob(File.join(root, '**', '*.html')).each do |document|
        original = File.read(document)
        finalized = original.gsub(LINK_TAG) do |tag|
          attributes = tag.scan(ATTRIBUTE).to_h { |name, _quote, value| [name.downcase, value] }
          next tag unless attributes.fetch('rel', '').downcase.split.include?('stylesheet')
          href = attributes['href']
          next tag unless href
          url = CGI.unescapeHTML(href)
          next tag if url.match?(%r{\A(?:[a-z][a-z0-9+.-]*:|//|#)}i)

          path_and_query, fragment = url.split('#', 2)
          path, query = path_and_query.split('?', 2)
          path = URI::DEFAULT_PARSER.unescape(path)
          path = path.delete_prefix(baseurl) if !baseurl.empty? && path.start_with?(baseurl + '/')
          target = if path.start_with?('/')
                     File.expand_path(path.delete_prefix('/'), root)
                   else
                     File.expand_path(path, File.dirname(document))
                   end
          unless target.start_with?(root + File::SEPARATOR)
            raise "Unsafe stylesheet path in #{File.basename(document)}"
          end
          unless File.file?(target)
            raise "Missing stylesheet: #{path}"
          end
          unless File.realpath(target).start_with?(root + File::SEPARATOR)
            raise "Unsafe stylesheet symlink: #{path}"
          end
          digest = Digest::SHA256.file(target).hexdigest
          parameters = query.to_s.split('&').reject { |part| part.start_with?('v=') || part.empty? }
          parameters << "v=#{digest}"
          public_path = path_and_query.split('?', 2).first
          resolved = public_path + '?' + parameters.join('&')
          resolved += '#' + fragment if fragment
          escaped = CGI.escapeHTML(resolved)
          tag.sub(/\bhref\s*=\s*(["'])(.*?)\1/i) { "href=#{$1}#{escaped}#{$1}" }
        end
        if finalized.include?(CSS_MARKER)
          raise "Unresolved stylesheet fingerprint in #{File.basename(document)}"
        end
        File.write(document, finalized) unless finalized == original
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::CacheBust)
