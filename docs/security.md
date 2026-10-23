# Security notes

## Controls included

- SSH ingress is limited to `admin_cidr`; set it to a trusted `/32` when administering from one public IP.
- Frontend HTTP is configurable through `http_cidrs` and defaults to public access for the demo.
- Backend TCP/19999 is allowed only from the frontend security group.
- EC2 metadata requires IMDSv2 tokens.
- Root EBS volumes are encrypted and deleted with the instance.
- The private key, generated inventory, Terraform state, and `terraform.tfvars` are excluded from Git.
- The workflow uses read-only repository permissions and does not apply infrastructure.

## Risks and next steps

- Netdata can expose sensitive host metrics. Avoid direct public access and add authentication/TLS or a private access path before production use.
- The demo uses public IPs and a default VPC. Prefer private subnets and AWS Systems Manager Session Manager where feasible.
- HTTP is unencrypted. Use TLS termination and an approved certificate strategy.
- Security groups do not replace host-level controls. The source PDF disables SELinux and firewalls; this repository deliberately does not disable them by default.
- Keep provider versions controlled and review Dependabot/security updates. Store shared Terraform state in an encrypted, versioned remote backend with locking.
- Use least-privilege IAM policies and short-lived credentials. Never put access keys or private keys in source control or GitHub workflow files.
