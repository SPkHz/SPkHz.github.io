# Validate the final public tree for every Jekyll build, including staging.
# Uses only Python's standard library; missing Python fails the build closed.
Jekyll::Hooks.register :site, :post_write do |site|
  validator = File.join(site.source, "scripts", "validate_public_artifacts.py")
  unless system("python3", validator, site.dest)
    raise Jekyll::Errors::FatalException, "Public artifact validation failed"
  end
end
