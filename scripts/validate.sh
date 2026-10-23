#!/usr/bin/env bash
set -euo pipefail

command -v terraform >/dev/null || { echo "terraform is required" >&2; exit 1; }
command -v ansible-playbook >/dev/null || { echo "ansible-playbook is required" >&2; exit 1; }

terraform -chdir=terraform fmt -recursive
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
ansible-playbook -i ansible/inventory/hosts.ini.example ansible/playbooks/site.yml --syntax-check
if command -v ansible-lint >/dev/null; then
  ansible-lint ansible/playbooks/site.yml
else
  echo "ansible-lint not installed; skipped lint check"
fi
