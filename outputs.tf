output "instance" {
  value = {
    vpn_instance = aws_instance.vpn_instance[*].id
    monitoring_frontend_instance = aws_instance.monitoring_fe_instance[*].id
    monitoring_backend_instance = aws_instance.monitoring_be_instance[*].id
    app_instance = aws_instance.k3s_instance[*].id
  }
}