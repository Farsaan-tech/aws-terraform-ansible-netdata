variable "aws_region" {
  description = "AWS region used for all resources. The source PDF used us-east-2."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Short project prefix used in AWS resource names."
  type        = string
  default     = "tf-ansible-netdata"
}

variable "environment" {
  description = "Environment tag and resource-name suffix."
  type        = string
  default     = "demo"
}

variable "admin_cidr" {
  description = "Trusted public IPv4 CIDR allowed to SSH to both instances; use /32 for one address."
  type        = string
  validation {
    condition     = can(cidrnetmask(var.admin_cidr))
    error_message = "admin_cidr must be a valid IPv4 CIDR block."
  }
}

variable "http_cidrs" {
  description = "IPv4 CIDRs allowed to access the frontend HTTP listener."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "public_key_path" {
  description = "Path to the public SSH key to register with EC2."
  type        = string
  default     = "~/.ssh/pipeline_key.pub"
}

variable "private_key_path" {
  description = "Path to the matching private SSH key; used only in generated inventory."
  type        = string
  default     = "~/.ssh/pipeline_key"
  sensitive   = true
}

variable "frontend_instance_type" {
  description = "EC2 instance type for the Nginx frontend."
  type        = string
  default     = "t3.micro"
}

variable "backend_instance_type" {
  description = "EC2 instance type for the Netdata backend."
  type        = string
  default     = "t3.micro"
}
