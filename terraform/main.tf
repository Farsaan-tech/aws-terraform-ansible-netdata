data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-${var.environment}-frontend"
  description = "SSH from administrator CIDR and public HTTP to Nginx"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH administration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }
  ingress {
    description = "HTTP reverse proxy"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.project_name}-${var.environment}-frontend-sg" }
}

resource "aws_security_group" "backend" {
  name        = "${var.project_name}-${var.environment}-backend"
  description = "SSH from administrator and Netdata from frontend only"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH administration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }
  ingress {
    description     = "Netdata from frontend only"
    from_port       = 19999
    to_port         = 19999
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.project_name}-${var.environment}-backend-sg" }
}

module "frontend" {
  source             = "./modules/ec2"
  name               = "${var.project_name}-${var.environment}-frontend"
  hostname           = "c8.local"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = var.frontend_instance_type
  subnet_id          = sort(data.aws_subnets.default.ids)[0]
  key_name           = aws_key_pair.deployment.key_name
  security_group_ids = [aws_security_group.frontend.id]
}

module "backend" {
  source             = "./modules/ec2"
  name               = "${var.project_name}-${var.environment}-backend"
  hostname           = "u21.local"
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.backend_instance_type
  subnet_id          = sort(data.aws_subnets.default.ids)[0]
  key_name           = aws_key_pair.deployment.key_name
  security_group_ids = [aws_security_group.backend.id]
}

resource "aws_key_pair" "deployment" {
  key_name   = "${var.project_name}-${var.environment}"
  public_key = file(pathexpand(var.public_key_path))
  tags       = { Name = "${var.project_name}-${var.environment}-key" }
}

resource "local_file" "ansible_inventory" {
  filename        = "${path.module}/../ansible/inventory/hosts.ini"
  file_permission = "0600"
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    frontend_ip       = module.frontend.public_ip
    backend_ip        = module.backend.public_ip
    backend_private_ip = module.backend.private_ip
    ssh_key            = pathexpand(var.private_key_path)
  })
}
