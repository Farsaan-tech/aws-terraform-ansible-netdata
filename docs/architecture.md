# Architecture and design decisions

## Request path

A browser sends HTTP traffic to the frontend EC2 instance on TCP/80. Nginx selects the backend host from the Ansible `backend` inventory group and proxies the request to Netdata on TCP/19999. The backend security group accepts 19999 only from the frontend security group. SSH is limited to the configured administrator CIDR.

## Provisioning and configuration flow

1. Terraform discovers the default VPC and its subnets in the configured region.
2. Terraform chooses the latest matching Amazon Linux 2023 and Ubuntu 22.04 LTS AMIs.
3. Terraform creates a key-pair registration, role-specific security groups, and two EC2 instances.
4. User data sets hostnames `c8.local` and `u21.local`.
5. Terraform writes an inventory file with public addresses and role groups.
6. Ansible applies the common baseline, then configures Nginx and Netdata.
7. An operator validates service status and opens the frontend URL.

## Architecture diagram description

For a polished diagram, show an AWS boundary containing a VPC and subnet. Inside the subnet, place the Nginx frontend and Netdata backend. Draw a public-client arrow to frontend TCP/80 and a private arrow from frontend to backend TCP/19999. Show an Ansible control node connecting over SSH to both hosts and Terraform provisioning both instances. Label SSH ingress as administrator-CIDR-only.

## Source fidelity and deviations

The source PDF used `us-east-2`, Amazon Linux for `c8.local`, Ubuntu 21.04 for `u21.local`, Nginx, Netdata, and a Terraform-created inventory concept. This repository keeps those roles and hostnames. It changes the Ubuntu AMI to Ubuntu 22.04 LTS because 21.04 is end-of-life, changes the Nginx listener to port 80 to match the stated requirement, uses a module, and adds explicit security groups. The source showed manual inventory editing; this repository generates the file automatically.

## Scope limitations

This is a compact demonstration architecture, not a fully hardened production platform. It uses public IP addresses and a default VPC, has no TLS, no load balancer, no remote Terraform state, and no high availability. Before production use, address these limitations and test in the target AWS account.
