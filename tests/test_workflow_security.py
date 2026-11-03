from pathlib import Path
import re
import unittest
import copy
import json
import subprocess

ROOT = Path(__file__).resolve().parents[1]
APPROVED = {
    'actions/checkout': '3d3c42e5aac5ba805825da76410c181273ba90b1',
    'actions/download-artifact': '9000827ccba6bdab643e8b6fd33ac0654aef8333',
    'actions/setup-node': '949feb2413d6458794dcd2491c4babbbce0c15c1',
    'ruby/setup-ruby': 'de492cf36cbab201753d720ce4f4e336cd688c94',
    'actions/configure-pages': '45bfe0192ca1faeb007ade9deae92b16b8254a0d',
    'actions/upload-pages-artifact': 'fc324d3547104276b827a68afc52ff2a11cc49c9',
    'actions/deploy-pages': '368f82528645a54fb793d4d04e342629a3f51346',
}
RELEASES = {
    'actions/checkout': 'v7.0.1',
    'actions/setup-node': 'v7.1.0',
    'actions/download-artifact': 'v8.0.2',
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
    check(set(jobs) == {'generate', 'checks', 'deploy'}, 'unexpected jobs')
    build = jobs.get('generate', {})
    quality = jobs.get('checks', {})
    deploy = jobs.get('deploy', {})
    check(build.get('permissions') == {'contents': 'read', 'pages': 'read'}, 'build permissions')
    check(deploy.get('permissions') == {'contents': 'read', 'pages': 'write', 'id-token': 'write'}, 'deploy permissions')
    check(deploy.get('if') == "github.event_name != 'pull_request' && github.ref == 'refs/heads/main'", 'effective deployment gate')
    check(deploy.get('needs') == ['generate', 'checks'], 'deployment dependency')
    check(deploy.get('environment', {}).get('name') == 'github-pages', 'deployment environment')
    check('environment' not in build, 'PR environment')
    check(quality.get('name') == 'Build and validate', 'required status name')
    events = workflow.get('on', workflow.get('true', {}))
    check(set(events) == {'pull_request', 'push', 'workflow_dispatch'}, 'workflow events')
    for event in ('push', 'pull_request'):
        check(events.get(event) == {'branches': ['main']}, 'event branch policy')
    check(quality.get('permissions') == {'contents': 'read'}, 'checks permissions')
    check(quality.get('needs') == 'generate', 'checks dependency')
    check(quality.get('if') == '${{ always() }}', 'checks always run')
    check(workflow.get('concurrency', {}).get('cancel-in-progress') == "${{ github.event_name == 'pull_request' }}", 'main deployment cancellation')
    first = quality.get('steps', [{}])[0]
    check(first.get('env', {}).get('GENERATION_RESULT') == '${{ needs.generate.result }}', 'generation result propagation')
    check(first.get('run') == 'test "$GENERATION_RESULT" = success', 'explicit fail-closed generation gate')
    check('environment' not in quality, 'checks environment')
    check(not re.search(r'\b(node|npm|npx)\b', json.dumps(build.get('steps', []))), 'Node in generation')
    uploads = [s for s in build.get('steps', []) if s.get('uses', '').startswith('actions/upload-pages-artifact@')]
    downloads = [s for s in quality.get('steps', []) if s.get('uses', '').startswith('actions/download-artifact@')]
    check(len(uploads) == len(downloads) == 1, 'artifact transfer multiplicity')
    if uploads and downloads:
        check(uploads[0].get('with', {}).get('name') == downloads[0].get('with', {}).get('name') == 'github-pages', 'artifact identity')
        check(downloads[0].get('with', {}).get('digest-mismatch') == 'error', 'artifact digest enforcement')
        check(set(downloads[0].get('with', {})) == {'name', 'path', 'digest-mismatch'}, 'cross-run artifact override')
    deploy_steps = deploy.get('steps', [])
    check(len(deploy_steps) == 1 and deploy_steps[0].get('with', {}).get('artifact_name') == 'github-pages', 'deploy exact artifact')
    commands = '\n'.join(step.get('run', '') for step in quality.get('steps', []))
    check('scripts/extract_pages_artifact.py' in commands and 'npm run js:check -- "$RUNNER_TEMP/validated-site"' in commands, 'artifact extraction and syntax gate')
    check(build.get('steps', [{}])[-1] in uploads, 'upload after generation validation')
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
                expected_job = 'checks' if name in ('actions/setup-node', 'actions/download-artifact') else 'generate'
                check(job_name == expected_job or (name == 'actions/checkout' and job_name == 'checks'), 'action placement')
            if name == 'actions/checkout':
                check(step.get('with', {}).get('persist-credentials') is False, 'persisted credentials')
    check(sorted(seen) == sorted([name + '@' + version for name, version in RELEASES.items()] + ['actions/checkout@v7.0.1']), 'action multiplicity')
    locked_refs = lock.get('workflows', {}).get('.github/workflows/pages.yml', [])
    check(len(locked_refs) == len(APPROVED), 'workflow lock mapping')
    mapped = {}
    for ref in locked_refs:
        dependency = lock.get('dependencies', {}).get(ref, {})
        mapped[ref.split('@')[0]] = dependency.get('commit', '').removeprefix('sha1-')
    check(mapped == APPROVED, 'locked action commits')
    return errors


class WorkflowSecurity(unittest.TestCase):
    def test_upload_preserves_security_contact(self):
        workflow = load_yaml(ROOT / '.github/workflows/pages.yml')
        upload = next(step for step in workflow['jobs']['generate']['steps']
                      if step.get('uses', '').startswith('actions/upload-pages-artifact@'))
        self.assertIs(upload.get('with', {}).get('include-hidden-files'), True,
                      'Pages archive must retain validated .well-known/security.txt')

    def test_structural_policy_and_negative_mutations(self):
        workflow = load_yaml(ROOT / '.github/workflows/pages.yml')
        lock = load_yaml(ROOT / '.github/workflows/actions.lock')
        self.assertEqual(policy_errors(workflow, lock), [])
        mutations = []
        missing_gate = copy.deepcopy(workflow)
        del missing_gate['jobs']['deploy']['if']
        mutations.append(missing_gate)
        pr_deployment = copy.deepcopy(workflow)
        pr_deployment['jobs']['generate']['steps'].append(copy.deepcopy(workflow['jobs']['deploy']['steps'][0]))
        mutations.append(pr_deployment)
        writable = copy.deepcopy(workflow)
        writable['permissions'] = {'contents': 'write'}
        mutations.append(writable)
        credentials = copy.deepcopy(workflow)
        credentials['jobs']['generate']['steps'][0]['with']['persist-credentials'] = True
        mutations.append(credentials)
        for field, value in (('if', '${{ success() }}'), ('needs', [])):
            changed = copy.deepcopy(workflow)
            changed['jobs']['checks'][field] = value
            mutations.append(changed)
        for field, value in (('digest-mismatch', 'warn'), ('name', 'other-artifact'), ('run-id', '123')):
            changed = copy.deepcopy(workflow)
            step = next(s for s in changed['jobs']['checks']['steps'] if s.get('uses', '').startswith('actions/download-artifact@'))
            step['with'][field] = value
            mutations.append(changed)
        changed = copy.deepcopy(workflow)
        changed['jobs']['checks']['steps'][0]['run'] = 'true'
        mutations.append(changed)
        for index, mutated in enumerate(mutations):
            with self.subTest(index=index):
                self.assertTrue(policy_errors(mutated, lock))
        bad_lock = copy.deepcopy(lock)
        bad_lock['dependencies']['actions/checkout@v7.0.1']['commit'] = 'sha1-' + '0' * 40
        self.assertTrue(policy_errors(workflow, bad_lock))
    def test_unsuccessful_generation_cannot_pass_required_gate(self):
        workflow = load_yaml(ROOT / '.github/workflows/pages.yml')
        first = workflow['jobs'].get('checks', {}).get('steps', [{}])[0]
        self.assertIn('run', first)
        for status in ('failure', 'cancelled', 'skipped', '', 'success'):
            with self.subTest(status=status):
                result = subprocess.run(['bash', '-euc', first['run']], env={'GENERATION_RESULT': status})
                self.assertEqual(result.returncode == 0, status == 'success')

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
