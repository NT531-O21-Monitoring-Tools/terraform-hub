output "eni_id" {
  value = aws_network_interface.eni.id
}

output "eni_private_ips" {
  value = aws_network_interface.eni.private_ips
}