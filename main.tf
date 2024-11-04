# List all avalability zones in the region
data "aws_availability_zones" "available" {}
locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.aws_vpc_config.number_of_availability_zones)
}

# Get Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  ec2_ami = var.ami != "" ? var.ami : data.aws_ami.ubuntu.id
}

# Create VPC with public and private subnets
module "vpc" {
  source = "./modules/vpc"

  name                 = var.aws_project
  vpc_cidr             = var.aws_vpc_config.cidr_block
  enable_dns_hostnames = var.aws_vpc_config.enable_dns_hostnames
  enable_dns_support   = var.aws_vpc_config.enable_dns_support
  public_subnets_cidr  = var.aws_vpc_config.public_subnets_cidr
  private_subnets_cidr = var.aws_vpc_config.private_subnets_cidr
  availability_zones   = local.selected_azs
  enable_nat_gateway   = var.aws_vpc_config.enable_nat_gateway
  eni_id               = module.vpn_server_eni.eni_id
}

# ENI
module "vpn_server_eni" {
    source = "./modules/eni"
    name = "eni"
    subnet_id = module.vpc.public_subnets[0]
    private_ips = [var.aws_eni_ip]
    security_group_ids = [module.vpn_server_sg.id]
}

# Create VPN Server
resource "aws_instance" "vpn_instance" {
  count         = var.vpn_instance_count
  ami           = local.ec2_ami
  instance_type = var.aws_instance_type

  key_name               = var.aws_key_name
  user_data              = file("./scripts/init-script.sh")

  network_interface {
    network_interface_id = module.vpn_server_eni.eni_id
    device_index         = 0
  }

  tags = {
    Name = "${var.aws_project}-VPN-instance-${count.index}"
  }
}

# Create Monitoring Frontend Servers
resource "aws_instance" "monitoring_fe_instance" {
  count                  = var.monitoring_frontend_instance_count
  ami                    = local.ec2_ami
  instance_type          = var.aws_instance_type

  key_name               = var.aws_key_name
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.monitoring_sg.id]

  tags = {
    Name = "${var.aws_project}-monitoring-fe-instance-${count.index}"
  }
}

# Create Monitoring Backend Servers
resource "aws_instance" "monitoring_be_instance" {
  count                  = var.monitoring_backend_instance_count
  ami                    = local.ec2_ami
  instance_type          = var.aws_instance_type

  key_name               = var.aws_key_name
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.monitoring_sg.id]

  tags = {
    Name = "${var.aws_project}-monitoring-be-instance-${count.index}"
  }
}

# Create K3s Cluster
resource "aws_instance" "k3s_instance" {
  count                  = var.app_instance_count
  ami                    = local.ec2_ami
  instance_type          = var.aws_instance_type

  key_name               = var.aws_key_name
  subnet_id              = module.vpc.private_subnets[1]
  vpc_security_group_ids = [module.apps_sg.id]

  tags = {
    Name = "${var.aws_project}-k3s-cluster-instance-${count.index}"
  }
}

# EBS for VPN server
resource "aws_ebs_volume" "vpn_ebs" {
  count             = var.vpn_instance_count
  availability_zone = local.selected_azs[count.index]
  size              = var.vpn_instance_ebs_size
}

resource "aws_volume_attachment" "vpn_ebs_attachment" {
  count       = var.vpn_instance_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.vpn_ebs[count.index].id
  instance_id = aws_instance.vpn_instance[count.index].id
}

# EBS for Monitoring Frontend
resource "aws_ebs_volume" "monitoring_fe_ebs" {
  count             = var.monitoring_frontend_instance_count
  availability_zone = local.selected_azs[count.index]
  size              = var.monitoring_frontend_instance_ebs_size
}

resource "aws_volume_attachment" "monitoring_fe_ebs_attachment" {
  count       = var.monitoring_frontend_instance_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.monitoring_fe_ebs[count.index].id
  instance_id = aws_instance.monitoring_fe_instance[count.index].id
}

# EBS for Monitoring Backend
resource "aws_ebs_volume" "monitoring_be_ebs" {
  count             = var.monitoring_backend_instance_count
  availability_zone = local.selected_azs[count.index]
  size              = var.monitoring_backend_instance_ebs_size
}

resource "aws_volume_attachment" "monitoring_be_ebs_attachment" {
  count       = var.monitoring_backend_instance_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.monitoring_be_ebs[count.index].id
  instance_id = aws_instance.monitoring_be_instance[count.index].id
}

# EBS for K3s Cluster
resource "aws_ebs_volume" "k3s_ebs" {
  count             = var.app_instance_count
  availability_zone = local.selected_azs[count.index]
  size              = var.app_instance_ebs_size
}

resource "aws_volume_attachment" "k3s_ebs_attachment" {
  count       = var.app_instance_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.k3s_ebs[count.index].id
  instance_id = aws_instance.k3s_instance[count.index].id
}
