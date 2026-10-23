# Career content

Use only statements you can explain and validate in an interview. Do not describe the repository as production-deployed unless you actually deployed and tested it.

## Project title

**AWS Infrastructure Automation with Terraform and Ansible — Nginx Reverse Proxy and Netdata Monitoring**

## Project description (approximately 150 words)

Designed an infrastructure automation project that provisions two AWS EC2 instances with Terraform and configures their roles using Ansible. The frontend instance runs Nginx as a reverse proxy, while the backend instance runs Netdata for host monitoring. Terraform manages the compute resources, security groups, SSH key registration, instance metadata settings, and outputs, and generates an Ansible inventory from the provisioned instance addresses. Ansible roles apply a common baseline, install Nginx and Netdata from operating-system package repositories, render the proxy configuration, and ensure the services are enabled. The network design restricts SSH to a configurable administrator CIDR and permits Netdata traffic only from the frontend security group. The repository includes deployment and teardown instructions, troubleshooting guidance, architecture documentation, example variables, and GitHub Actions checks for Terraform and Ansible. The implementation also documents important source-project corrections, including the Nginx listener mismatch and the end-of-life status of Ubuntu 21.04.

## Resume bullets

- Provisioned AWS EC2 infrastructure with reusable Terraform modules, variable-driven configuration, resource tagging, and outputs.
- Automated host configuration using Ansible roles for common setup, Nginx reverse proxy, and Netdata monitoring.
- Generated Ansible inventory dynamically from Terraform outputs to remove manual public-IP copy/paste steps.
- Configured Nginx to proxy HTTP requests on TCP/80 to Netdata on TCP/19999.
- Applied least-exposure security-group rules, limiting SSH to an administrator CIDR and backend monitoring traffic to the frontend security group.
- Added GitHub Actions checks for Terraform formatting/validation and Ansible lint/syntax validation.
- Documented provisioning, verification, troubleshooting, and teardown procedures to support repeatable deployments.
- Reviewed source implementation risks, including an end-of-life operating system and a reverse-proxy port mismatch.

## LinkedIn project description

Built an AWS infrastructure automation project using Terraform and Ansible to provision two EC2 instances and configure an Nginx-to-Netdata monitoring path. Terraform creates the infrastructure and generates Ansible inventory; Ansible configures the frontend reverse proxy and backend monitoring service. Added scoped security-group rules, deployment validation steps, architecture documentation, and GitHub Actions static checks. The repository records design trade-offs and improvements made to the original implementation.

## Interview talking points

- Why Terraform outputs are used to generate inventory.
- How Nginx discovers backend hosts from the Ansible inventory group.
- Why port 19999 should not be publicly exposed.
- Why Ubuntu 21.04 was replaced with an LTS release.
- Why `terraform apply` is not run automatically in CI.
- What additional work is required before production deployment.
