output "instance_ips" {
    value = {
        bastion_instance = aws_instance.bastion_instance[*].private_ip
        monitoring_frontend_instance = aws_instance.monitoring_fe_instance[*].private_ip
        monitoring_backend_instance = aws_instance.monitoring_be_instance[*].private_ip
        cluster_instance = aws_instance.k3s_instance[*].private_ip
    }
}

output "bastion_instance_ip_public" {
    value = aws_instance.bastion_instance[*].public_ip
}