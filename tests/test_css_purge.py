from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class CssPurge(unittest.TestCase):
    def test_runtime_mathjax_styles_survive_purge(self):
        script = r'''
const { PurgeCSS } = require('purgecss');
const config = require('./purgecss.config.js');
(async () => {
  const results = await new PurgeCSS().purge({
    ...config,
    content: [{raw: '<div class="post"><article><p>Math loads at runtime.</p></article></div>', extension: 'html'}],
    css: [{raw: '.post article mjx-container[jax="CHTML"]:not([display="true"]){max-width:100%;overflow-x:auto} mjx-container[jax="CHTML"][display="true"]{overflow-x:auto} .unused-fixture{color:red}'}],
  });
  process.stdout.write(results[0].css);
})();
'''
        result = subprocess.run(['node', '-e', script], cwd=ROOT,
                                text=True, capture_output=True, check=True)
        self.assertIn('max-width:100%', result.stdout)
        self.assertIn('mjx-container[jax="CHTML"][display="true"]', result.stdout)
        self.assertNotIn('.unused-fixture', result.stdout)
