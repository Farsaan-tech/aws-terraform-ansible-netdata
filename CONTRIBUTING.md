# Contributing

Thank you for helping improve the project. Keep changes focused, reproducible, and security-conscious.

## Before opening a pull request

1. Describe the problem and the proposed change.
2. Do not commit credentials, private keys, generated inventory, Terraform state, or real account identifiers.
3. Run Terraform formatting and validation:
   ```bash
   cd terraform
   terraform fmt -recursive
   terraform init -backend=false
   terraform validate
   ```
4. Run Ansible syntax and lint checks where the tools are available:
   ```bash
   cd ../ansible
   ansible-playbook -i inventory/hosts.ini.example playbooks/site.yml --syntax-check
   ansible-lint playbooks/site.yml
   ```
5. Update documentation and `CHANGELOG.md` when behavior changes.
6. Include sanitized evidence for changes that affect deployment behavior.

## Style

- Use descriptive Terraform resource and variable names.
- Prefer Ansible modules over shell commands.
- Keep secrets outside the repository.
- Make playbooks idempotent and handlers event-driven.
- Explain compatibility or security trade-offs in documentation.

## Pull requests

Include the motivation, summary of changes, validation performed, and any operational risks. Do not claim live AWS validation unless you personally ran it and can describe the environment.
