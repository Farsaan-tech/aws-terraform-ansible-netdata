# Changelog

All notable changes to this project are documented here.

## [1.0.0] - 2026-10-23

### Added
- Modular Terraform configuration for frontend and backend EC2 instances.
- Dedicated frontend and backend security groups.
- Terraform-generated Ansible inventory.
- Ansible roles for common configuration, Nginx reverse proxy, and Netdata.
- GitHub Actions static validation workflow.
- Deployment, architecture, security, and career documentation.
- Selected evidence screenshots extracted from the source PDF.

### Changed
- Corrected Nginx to listen on port 80 and proxy to backend port 19999.
- Used a supported Ubuntu LTS image lookup instead of assuming Ubuntu 21.04 is suitable for a new deployment.
- Avoided disabling SELinux or host firewalls by default.

### Notes
- This release has not been deployed by the repository generator. Run the documented checks and validate in your own AWS account before relying on it.
