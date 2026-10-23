"""Exercise the real Jekyll publication hook without loading site plugins."""
from pathlib import Path
import json
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(shutil.which("ruby"), "BLOCKED: Ruby is unavailable; no installation authorized")
class JekyllPublicationTest(unittest.TestCase):
    def test_post_write_hook_blocks_unsafe_output(self):
        runner = """
module Jekyll
  module Errors
    class FatalException < StandardError; end
  end
  module Hooks
    def self.register(scope, event, &block)
      raise "wrong build lifecycle" unless scope == :site && event == :post_write
      @callback = block
    end
    def self.invoke(site); @callback.call(site); end
  end
end
load ARGV[0]
Jekyll::Hooks.invoke(Struct.new(:source, :dest).new(ARGV[1], ARGV[2]))
"""
        with tempfile.TemporaryDirectory() as name:
            output = Path(name) / "_site"
            output.mkdir()
            (output / "index.html").write_text("public")
            args = ["ruby", "-e", runner, str(ROOT / "_plugins/validate_public_artifacts.rb"), str(ROOT), str(output)]
            good = subprocess.run(args, capture_output=True, text=True)
            self.assertEqual(good.returncode, 0, good.stderr)
            (output / "AGENTS.md").write_text("SYNTHETIC PRIVATE")
            bad = subprocess.run(args, capture_output=True, text=True)
            self.assertNotEqual(bad.returncode, 0)
            self.assertIn("Public artifact validation failed", bad.stderr)
            self.assertNotIn("SYNTHETIC PRIVATE", bad.stderr)

    def test_staging_overlay_preserves_public_exclusions(self):
        configs = [ROOT / "_config.yml"]
        if (ROOT / "_config_staging.yml").exists():
            configs.append(ROOT / "_config_staging.yml")
        code = "require 'yaml'; require 'json'; c={}; ARGV.each {|p| c.merge!(YAML.load_file(p, aliases: true))}; puts JSON.generate({include: c['include'], exclude: c['exclude']})"
        result = subprocess.run(["ruby", "-e", code, *map(str, configs)], capture_output=True, text=True, check=True)
        config = json.loads(result.stdout)
        self.assertNotIn("_scripts", config["include"])
        for path in ("README.md", "HUMAN_README.md", "AGENTS.md", "CLAUDE.md", "FAQ.md", "_scripts", "docs", "scripts", "tests", ".agents", ".codex", ".claude"):
            self.assertIn(path, config["exclude"])


if __name__ == "__main__":
    unittest.main()
