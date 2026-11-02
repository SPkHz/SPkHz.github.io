require 'open3'

Jekyll::Hooks.register :site, :post_write do |site|
  validator = File.join(site.source, 'scripts', 'validate_public_artifacts.py')
  output, status = Open3.capture2e('python3', '-B', validator, site.dest)
  unless status.success?
    raise Jekyll::Errors::FatalException, "Public artifact validation failed:\n#{output}"
  end
end
