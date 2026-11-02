import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DevcontainerSecurity(unittest.TestCase):
    def setUp(self):
        self.config = json.loads((ROOT / '.devcontainer/devcontainer.json').read_text())

    def test_immutable_image(self):
        self.assertRegex(self.config['image'], r'@sha256:[0-9a-f]{64}$')

    def test_rootless_restrictions(self):
        for argument in ('--userns=keep-id', '--security-opt=no-new-privileges'):
            self.assertIn(argument, self.config.get('runArgs', []))
        for key in ('containerUser', 'remoteUser'):
            self.assertEqual(self.config.get(key), 'vscode')
        for key in ('privileged', 'capAdd', 'mounts', 'postStartCommand', 'postAttachCommand'):
            self.assertFalse(self.config.get(key))

    def test_no_host_identity_or_ai_extensions(self):
        serialized = json.dumps(self.config).lower()
        for value in ('.gitconfig', '.ssh', 'docker.sock', 'openai.chatgpt', 'anthropic.claude'):
            self.assertNotIn(value, serialized)

    def test_no_legacy_container_surface(self):
        for path in ('Dockerfile', '.dockerignore', 'docker-compose.yml', 'docker-compose-slim.yml',
                     'bin/deploy', 'bin/cibuild', 'bin/entry_point.sh', '.devcontainer/.gitconfig',
                     '.devcontainer/.codex/skills/context7.md'):
            with self.subTest(path=path):
                self.assertFalse((ROOT / path).exists())

    def test_feature_resolutions_locked(self):
        lock = ROOT / '.devcontainer/devcontainer-lock.json'
        self.assertTrue(lock.is_file())
        features = json.loads(lock.read_text())['features']
        self.assertEqual(set(features), set(self.config['features']))
        for feature in features.values():
            self.assertRegex(feature['resolved'], r'@sha256:[0-9a-f]{64}$')
            self.assertTrue(feature['integrity'])


if __name__ == '__main__':
    unittest.main()
