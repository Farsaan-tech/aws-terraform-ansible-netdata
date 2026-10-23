# Deployment guide

## 1. Prepare a control machine

Install Terraform, AWS CLI v2, Ansible Core, and `ansible-lint`. Configure AWS credentials using a profile or IAM role. Confirm the chosen region has a default VPC and at least one subnet.

Create a key pair if needed:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/pipeline_key
chmod 600 ~/.ssh/pipeline_key
```

Use a key type accepted by your target AMI and environment. Register only the public key with AWS; the private key stays on the control node.

## 2. Set variables and provision

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `admin_cidr` to your current trusted public IP in CIDR notation. Check key paths, region, and instance types. Then run:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output
```

Review the plan and estimated costs before approval. The generated inventory is written to `ansible/inventory/hosts.ini`.

## 3. Check inventory and connectivity

```bash
cd ../ansible
ansible-inventory -i inventory/hosts.ini --graph
ansible all -i inventory/hosts.ini -m ping
```

If SSH fails, confirm the administrator CIDR, public IPs, username, private key permissions, and route to the instances. Amazon Linux normally uses `ec2-user`; Ubuntu uses `ubuntu`.

## 4. Apply configuration

```bash
ansible-playbook -i inventory/hosts.ini playbooks/site.yml --syntax-check
ansible-playbook -i inventory/hosts.ini playbooks/site.yml
```

The playbook installs Nginx and Netdata through the configured OS package repositories, renders the proxy config, and enables both services. Package availability can vary by AMI and repository state.

## 5. Validate the application

```bash
ansible -i inventory/hosts.ini frontend -b -m command -a 'nginx -t'
ansible -i inventory/hosts.ini frontend -b -m command -a 'systemctl is-active nginx'
ansible -i inventory/hosts.ini backend -b -m command -a 'systemctl is-active netdata'
curl -I "$(cd ../terraform && terraform output -raw application_url)"
```

Open the URL from `terraform output -raw application_url`. If Netdata returns a redirect or UI response rather than `200`, inspect the browser and Nginx logs before treating it as a failure; the exact HTTP status can depend on application behavior.

## 6. Troubleshooting

- **SSH timeout:** check security groups, route table, subnet public-IP assignment, and `admin_cidr`.
- **Ansible Python errors:** confirm Python 3 is installed on the target; the common role installs it on Amazon Linux.
- **Nginx config test fails:** run `sudo nginx -t` on the frontend and inspect `/var/log/nginx/error.log`.
- **Proxy returns 502:** check `systemctl status netdata`, backend security-group ingress on 19999, and reachability from frontend to backend.
- **Netdata package unavailable:** verify the selected Ubuntu AMI and configured APT repositories. The original Ubuntu 21.04 release is end-of-life and should not be used for a new deployment.

## 7. Tear down

```bash
cd ../terraform
terraform destroy
```

Review the destroy plan carefully. Keep evidence or logs you need before deleting the environment. Terraform's local state and generated inventory are ignored by Git and must not be committed.
