# Professional commit history examples

Use these as examples of a clear, reviewable history. They are illustrative messages, not claims that these commits already exist in the repository.

```text
chore(terraform): define AWS provider and input variables
feat(terraform): provision frontend and backend EC2 instances
feat(network): restrict backend Netdata access to frontend security group
feat(terraform): generate Ansible inventory from instance outputs
feat(ansible): add common baseline role for supported Linux hosts
feat(nginx): proxy frontend HTTP traffic to Netdata backend
feat(netdata): install and enable backend monitoring service
ci(github-actions): validate Terraform and lint Ansible playbooks
docs(readme): document deployment, verification, and teardown
fix(nginx): listen on port 80 to match the documented request path
security(ec2): require IMDSv2 and encrypt root volumes
```

## Commit practices

- Keep each commit focused on one change.
- Prefer imperative, specific subjects with a conventional prefix.
- Do not commit credentials, Terraform state, private keys, generated inventory, or live public addresses.
- Avoid claiming deployment validation in a commit unless the check was actually run.
