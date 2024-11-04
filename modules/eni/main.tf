# ENI
resource "aws_network_interface" "eni" {
  subnet_id = var.subnet_id
  private_ips = var.private_ips
  security_groups = var.security_group_ids

  tags = {
    Name = "${var.name}-eni"
  }
}
