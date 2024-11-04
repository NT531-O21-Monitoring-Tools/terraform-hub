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

# EC2 Instance
resource "aws_instance" "this" {
  count         = var.instance_count
  ami           = local.ec2_ami
  instance_type = var.instance_type

  key_name               = var.key_name
  user_data              = var.user_data != "" ? var.user_data : null
  subnet_id              = length(var.subnets_id) > 0 ? var.subnets_id[0] : null
  vpc_security_group_ids = var.sgs_id != null ? var.sgs_id : []

  dynamic "network_interface" {
    for_each = var.eni_ids
    content {
      device_index         = network_interface.key
      network_interface_id = network_interface.value
    }
  }

  tags = {
    Name = "${var.name}-instance-${count.index}"
  }
}
