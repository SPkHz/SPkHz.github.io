"""Inert Python consumer regressions: no live Scholar or browser requests."""

import contextlib
import importlib.util
from pathlib import Path
import sys
import tempfile
import types
import unittest
from unittest import mock

import yaml

ROOT = Path(__file__).resolve().parents[2]


class PythonConsumerTests(unittest.TestCase):
    def test_real_citation_dependency_interface(self):
        if importlib.util.find_spec("scholarly") is None:
            self.skipTest("build-only environment excludes citation dependencies")
        from scholarly import scholarly
        from bibtexparser.bibdatabase import BibDatabase
        self.assertTrue(callable(scholarly.search_author_id))
        self.assertIsInstance(BibDatabase().entries, list)

    def test_citations_create_missing_output_with_mocked_provider(self):
        with tempfile.TemporaryDirectory() as directory:
            fixture = Path(directory)
            (fixture / "_data").mkdir()
            (fixture / "_data/socials.yml").write_text("scholar_userid: synthetic-id\n")
            provider = mock.Mock()
            provider.search_author_id.return_value = {"synthetic": True}
            provider.fill.return_value = {"publications": [{"pub_id": "synthetic-paper",
                "bib": {"title": "Inert synthetic title", "pub_year": "2026"}, "num_citations": 3}]}
            with contextlib.chdir(fixture), mock.patch.dict(sys.modules, {"scholarly": types.SimpleNamespace(scholarly=provider)}):
                spec = importlib.util.spec_from_file_location("citation_fixture", ROOT / "bin/update_scholar_citations.py")
                module = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(module)
                module.get_scholar_citations()
                data = yaml.safe_load((fixture / "_data/citations.yml").read_text())
                self.assertEqual(data["papers"]["synthetic-paper"]["citations"], 3)
                provider.search_author_id.reset_mock()
                module.get_scholar_citations()
                provider.search_author_id.assert_not_called()

    def test_nbconvert_sanitizes_traversal_and_empty_basename(self):
        import nbformat
        from nbconvert import MarkdownExporter
        outputs = [nbformat.v4.new_output("display_data", data={"image/png": "c3ludGhldGlj"},
                   metadata={"filename": name}) for name in ("../outside.png", "/")]
        notebook = nbformat.v4.new_notebook(cells=[nbformat.v4.new_code_cell("pass", outputs=outputs)])
        _, resources = MarkdownExporter().from_notebook_node(notebook)
        self.assertEqual(list(resources["outputs"]), ["outside.png"])

    def test_inert_notebook_renders_without_execution(self):
        import nbformat
        from nbconvert import HTMLExporter
        notebook = nbformat.v4.new_notebook(cells=[nbformat.v4.new_markdown_cell("# Inert fixture\n\nPlain text.")])
        output, _ = HTMLExporter().from_notebook_node(notebook)
        self.assertIn("Inert fixture", output)

    def test_workflows_use_own_hash_locks(self):
        for name in ("deploy", "axe", "broken-links-site"):
            workflow = (ROOT / f".github/workflows/{name}.yml").read_text()
            self.assertIn(".github/python-installer/requirements.lock", workflow)
            self.assertIn(".github/python-build-tools/requirements.lock", workflow)
            self.assertIn("--require-hashes --only-binary=:all:", workflow)
            self.assertNotIn("pip3 install --upgrade", workflow)
        citation = (ROOT / ".github/workflows/update-citations.yml").read_text()
        self.assertIn("-r requirements.lock", citation)
        self.assertNotIn("pip install --upgrade pip", citation)


if __name__ == "__main__":
    unittest.main()
