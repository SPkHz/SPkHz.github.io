require 'jekyll-imagemagick'
require 'pathname'

# The upstream generator scans the filesystem, bypassing Jekyll's static-file
# exclusions. Apply the same explicit source exclusions before conversion.
module ImagePublication
  private

  def get_files_to_transform(site, directories, formats)
    super.reject do |file|
      relative = Pathname.new(file).relative_path_from(Pathname.new(site.source)).to_s
      site.config.fetch('exclude', []).any? do |excluded|
        prefix = excluded.to_s.delete_suffix('/')
        relative == prefix || relative.start_with?(prefix + '/') ||
          File.fnmatch?(prefix, relative, File::FNM_PATHNAME | File::FNM_DOTMATCH)
      end
    end
  end
end

JekyllImagemagick::ImageGenerator.prepend(ImagePublication)
