# Generate inventory file from terraform state
resource "local_file" "inventory" {
  content = templatefile("./templates/inventory.yml.tftpl",
    {
        bastion_ip = aws_instance.bastion_instance.*.private_ip,
        bastion_id = aws_instance.bastion_instance.*.id,
        monitoring_fe_ip = aws_instance.monitoring_fe_instance.*.private_ip,
        monitoring_fe_id = aws_instance.monitoring_fe_instance.*.id,
        monitoring_be_ip = aws_instance.monitoring_be_instance.*.private_ip,
        monitoring_be_id = aws_instance.monitoring_be_instance.*.id,
        cluster_ip = aws_instance.cluster_instance.*.private_ip,
        cluster_id = aws_instance.cluster_instance.*.id,
    }
  )
  filename = "${path.root}/inventory.yml"
}