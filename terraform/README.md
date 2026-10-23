# Terraform

The root module discovers a default VPC/subnet, selects current Amazon Linux 2023 and Ubuntu 22.04 LTS AMIs, creates role-specific security groups and two instances, then writes the Ansible inventory to `../ansible/inventory/hosts.ini`.

The source PDF used Ubuntu 21.04. That release is end-of-life, so this repository uses Ubuntu 22.04 LTS by default. The original hostname `u21.local` is retained to match the assignment naming, even though the OS release is now 22.04; consider renaming it if the hostname is not a compatibility requirement.

Run from this directory: `terraform init`, `terraform fmt -recursive`, `terraform validate`, `terraform plan`, and `terraform apply`. Review all planned changes first.
