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

# ENIs
# module "bastion_eni" {
#   source = "./modules/eni"
#   eni_count = var.bastion_instance_count
#   name = "bastion_eni"
#   subnet_id = module.vpc.public_subnets[0]
#   private_ips = [var.bastion_eni_ip]
#   security_group_ids = [module.bastion_sg.id]
# }

# module "monitoring_fe_eni" {
#   source = "./modules/eni"
#   eni_count = var.monitoring_frontend_instance_count
#   name = "monitoring_fe_eni"
#   subnet_id = module.vpc.private_subnets[1]
#   private_ips = [var.monitoring_frontend_eni_ip]
#   security_group_ids = [module.monitoring_sg.id]
# }

# module "monitoring_be_eni" {
#   source = "./modules/eni"
#   eni_count = var.monitoring_backend_instance_count
#   name = "monitoring_be_eni"
#   subnet_id = module.vpc.private_subnets[1]
#   private_ips = [var.monitoring_backend_eni_ip]
#   security_group_ids = [module.monitoring_sg.id]
# }

# module "cluster_eni" {
#   source = "./modules/eni"
#   eni_count = length(var.cluster_eni_ips)
#   name = "cluster_eni"
#   subnet_id = module.vpc.private_subnets[0]
#   private_ips = var.cluster_eni_ips
#   security_group_ids = [module.cluster_sg.id]
# }

resource "aws_network_interface" "bastion_eni" {
  count             = var.bastion_instance_count
  subnet_id         = module.vpc.public_subnets[0]
  private_ips       = [var.bastion_eni_ip]
  security_groups   = [module.bastion_sg.id]
  source_dest_check = false

  tags = {
    Name = "${var.aws_project}-bastion_eni"
  }
}

resource "aws_network_interface" "monitoring_fe_eni" {
  count             = var.monitoring_frontend_instance_count
  subnet_id         = module.vpc.private_subnets[1]
  private_ips       = [var.monitoring_frontend_eni_ip]
  security_groups   = [module.monitoring_sg.id]

  tags = {
    Name = "${var.aws_project}-monitoring_fe_eni"
  }
}

resource "aws_network_interface" "monitoring_be_eni" {
  count             = var.monitoring_backend_instance_count
  subnet_id         = module.vpc.private_subnets[1]
  private_ips       = [var.monitoring_backend_eni_ip]
  security_groups   = [module.monitoring_sg.id]

  tags = {
    Name = "${var.aws_project}-monitoring_be_eni"
  }
}

resource "aws_network_interface" "cluster_eni" {
  count             = length(var.cluster_eni_ips)
  subnet_id         = module.vpc.private_subnets[0]
  private_ips       = var.cluster_eni_ips
  security_groups   = [module.cluster_sg.id]

  tags = {
    Name = "${var.aws_project}-cluster_eni"
  }
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
  eni_id               = aws_network_interface.bastion_eni[0].id
}

# Create VPN Server
resource "aws_instance" "bastion_instance" {
  count         = var.bastion_instance_count
  ami           = local.ec2_ami
  instance_type = var.aws_instance_type

  key_name               = var.aws_key_name
  user_data              = file("./scripts/init-script.sh")

  network_interface {
    network_interface_id = aws_network_interface.bastion_eni[count.index].id
    device_index         = 0
  }

  root_block_device {
    volume_size = var.bastion_instance_ebs_size
  }

  tags = {
    Name = "${var.aws_project}-bastion-instance-${count.index}"
  }
}

# Create Monitoring Frontend Servers
resource "aws_instance" "monitoring_fe_instance" {
  count                  = var.monitoring_frontend_instance_count
  ami                    = local.ec2_ami
  instance_type          = var.aws_instance_type

  key_name               = var.aws_key_name

  network_interface {
    network_interface_id = aws_network_interface.monitoring_fe_eni[count.index].id
    device_index         = 0
  }

  root_block_device {
    volume_size = var.monitoring_frontend_instance_ebs_size
  }

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

  network_interface {
    network_interface_id = aws_network_interface.monitoring_be_eni[count.index].id
    device_index         = 0
  }

  root_block_device {
    volume_size = var.monitoring_backend_instance_ebs_size
  }

  tags = {
    Name = "${var.aws_project}-monitoring-be-instance-${count.index}"
  }
}

# Create K3s Cluster
resource "aws_instance" "k3s_instance" {
  count                  = var.cluster_instance_count
  ami                    = local.ec2_ami
  instance_type          = var.aws_instance_type

  key_name               = var.aws_key_name

  network_interface {
    network_interface_id = aws_network_interface.cluster_eni[count.index].id
    device_index         = 0
  }

  root_block_device {
    volume_size = var.cluster_instance_ebs_size
  }

  tags = {
    Name = "${var.aws_project}-cluster-instance-${count.index}"
  }
}