output "instance" {
  value = {
    vpn_instance = aws_instance.vpn_instance[*].id
    monitoring_frontend_instance = aws_instance.monitoring_fe_instance[*].id
    monitoring_backend_instance = aws_instance.monitoring_be_instance[*].id
    app_instance = aws_instance.k3s_instance[*].id
  }
}

output "instance_ips" {
  value = {
    vpn_instance = aws_instance.vpn_instance[*].private_ip
    monitoring_frontend_instance = aws_instance.monitoring_fe_instance[*].private_ip
    monitoring_backend_instance = aws_instance.monitoring_be_instance[*].private_ip
    app_instance = aws_instance.k3s_instance[*].private_ip
  }
}

output "vpn_public_ip" {
  value = aws_instance.vpn_instance[*].public_ip
}
