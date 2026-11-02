from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class JekyllPublication(unittest.TestCase):
    def test_profile_sources_use_board_and_alt(self):
        for name in ('about.md', 'profiles.md'):
            text = (ROOT / '_pages' / name).read_text()
            self.assertIn('image: kicad_main_board.png', text)
            self.assertIn('image_alt: KiCad PCB layout for an RF/microwave main board', text)
            self.assertNotIn('prof_pic', text)

    def test_search_input_and_security_contact(self):
        config = (ROOT / '_config.yml').read_text()
        self.assertIn('"_scripts"', config)
        self.assertIn('".well-known"', config)
        self.assertTrue((ROOT / '_plugins/validate_public_artifacts.rb').is_file())
        self.assertTrue((ROOT / '.well-known/security.txt').is_file())
