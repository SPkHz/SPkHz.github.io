from pathlib import Path
import re
import unittest
import copy
import json
import subprocess

ROOT = Path(__file__).resolve().parents[1]
APPROVED = {
    'actions/checkout': '3d3c42e5aac5ba805825da76410c181273ba90b1',
    'actions/setup-node': '949feb2413d6458794dcd2491c4babbbce0c15c1',
    'ruby/setup-ruby': 'de492cf36cbab201753d720ce4f4e336cd688c94',
    'actions/configure-pages': '45bfe0192ca1faeb007ade9deae92b16b8254a0d',
    'actions/upload-pages-artifact': 'fc324d3547104276b827a68afc52ff2a11cc49c9',
    'actions/deploy-pages': '368f82528645a54fb793d4d04e342629a3f51346',
}
RELEASES = {
    'actions/checkout': 'v7.0.1',
    'actions/setup-node': 'v7.1.0',
    'ruby/setup-ruby': 'v1.336.0',
    'actions/configure-pages': 'v6.0.0',
    'actions/upload-pages-artifact': 'v5.0.0',
    'actions/deploy-pages': 'v5.0.1',
}


def load_yaml(path):
    result = subprocess.run(['ruby', '-ryaml', '-rjson', '-e',
                             'puts JSON.generate(YAML.load_file(ARGV[0], aliases: true))', str(path)],
                            check=True, capture_output=True, text=True)
    return json.loads(result.stdout)


def policy_errors(workflow, lock):
    errors = []
    def check(condition, message):
        if not condition:
            errors.append(message)
    check(workflow.get('permissions') == {}, 'default permissions')
    jobs = workflow.get('jobs', {})
    check(set(jobs) == {'build', 'deploy'}, 'unexpected jobs')
    build = jobs.get('build', {})
    deploy = jobs.get('deploy', {})
    check(build.get('permissions') == {'contents': 'read', 'pages': 'read'}, 'build permissions')
    check(deploy.get('permissions') == {'contents': 'read', 'pages': 'write', 'id-token': 'write'}, 'deploy permissions')
    check(deploy.get('if') == "github.event_name != 'pull_request' && github.ref == 'refs/heads/main'", 'effective deployment gate')
    check(deploy.get('needs') == 'build', 'deployment dependency')
    check(deploy.get('environment', {}).get('name') == 'github-pages', 'deployment environment')
    check('environment' not in build, 'PR environment')
    check(build.get('name') == 'Build and validate', 'required status name')
    events = workflow.get('on', workflow.get('true', {}))
    check(set(events) == {'pull_request', 'push', 'workflow_dispatch'}, 'workflow events')
    for event in ('push', 'pull_request'):
        check(events.get(event) == {'branches': ['main']}, 'event branch policy')
    seen = []
    for job_name, job in jobs.items():
        check(isinstance(job.get('timeout-minutes'), int), 'job timeout')
        for step in job.get('steps', []):
            if 'uses' not in step:
                continue
            ref = step['uses']
            seen.append(ref)
            name, _, sha = ref.partition('@')
            check(RELEASES.get(name) == sha, 'unapproved action release')
            if name == 'actions/deploy-pages':
                check(job_name == 'deploy', 'deployment outside deployment job')
            else:
                check(job_name == 'build', 'build action outside build job')
            if name == 'actions/checkout':
                check(step.get('with', {}).get('persist-credentials') is False, 'persisted credentials')
    check(sorted(seen) == sorted(name + '@' + version for name, version in RELEASES.items()), 'action multiplicity')
    locked_refs = lock.get('workflows', {}).get('.github/workflows/pages.yml', [])
    check(len(locked_refs) == len(APPROVED), 'workflow lock mapping')
    mapped = {}
    for ref in locked_refs:
        dependency = lock.get('dependencies', {}).get(ref, {})
        mapped[ref.split('@')[0]] = dependency.get('commit', '').removeprefix('sha1-')
    check(mapped == APPROVED, 'locked action commits')
    return errors


class WorkflowSecurity(unittest.TestCase):
    def test_structural_policy_and_negative_mutations(self):
        workflow = load_yaml(ROOT / '.github/workflows/pages.yml')
        lock = load_yaml(ROOT / '.github/workflows/actions.lock')
        self.assertEqual(policy_errors(workflow, lock), [])
        mutations = []
        missing_gate = copy.deepcopy(workflow)
        del missing_gate['jobs']['deploy']['if']
        mutations.append(missing_gate)
        pr_deployment = copy.deepcopy(workflow)
        pr_deployment['jobs']['build']['steps'].append(copy.deepcopy(workflow['jobs']['deploy']['steps'][0]))
        mutations.append(pr_deployment)
        writable = copy.deepcopy(workflow)
        writable['permissions'] = {'contents': 'write'}
        mutations.append(writable)
        credentials = copy.deepcopy(workflow)
        credentials['jobs']['build']['steps'][0]['with']['persist-credentials'] = True
        mutations.append(credentials)
        for index, mutated in enumerate(mutations):
            with self.subTest(index=index):
                self.assertTrue(policy_errors(mutated, lock))
        bad_lock = copy.deepcopy(lock)
        bad_lock['dependencies']['actions/checkout@v7.0.1']['commit'] = 'sha1-' + '0' * 40
        self.assertTrue(policy_errors(workflow, bad_lock))
    def test_single_workflow_and_approved_actions(self):
        directory = ROOT / '.github/workflows'
        workflows = sorted([*directory.glob('*.yml'), *directory.glob('*.yaml')])
        self.assertEqual([p.name for p in workflows], ['pages.yml'])
        text = workflows[0].read_text()
        uses = re.findall(r'uses:\s*([^\s#]+)', text)
        self.assertEqual(set(uses), {name + '@' + version for name, version in RELEASES.items()})

    def test_token_and_deployment_boundaries(self):
        path = ROOT / '.github/workflows/pages.yml'
        self.assertTrue(path.is_file())
        text = path.read_text()
        self.assertIn('\npermissions: {}\n', text)
        self.assertIn('persist-credentials: false', text)
        self.assertIn("github.event_name != 'pull_request' && github.ref == 'refs/heads/main'", text)
        self.assertIn('name: Build and validate', text)
        for forbidden in ('pull_request_target', 'secrets.', 'contents: write', 'git push', 'curl ', '${{ github.event.'):
            self.assertNotIn(forbidden, text)

    def test_generated_lock_exists(self):
        path = ROOT / '.github/workflows/actions.lock'
        self.assertTrue(path.is_file())
        lock = path.read_text()
        for sha in APPROVED.values():
            self.assertIn(sha, lock)
