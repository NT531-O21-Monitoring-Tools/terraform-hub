# ENI
resource "aws_network_interface" "eni" {
  count             = var.eni_count
  subnet_id         = var.subnet_id
  private_ips       = var.private_ips
  security_groups   = var.security_group_ids
  source_dest_check = false

  tags = {
    Name = "${var.name}-eni"
  }
}
