# Output for Public EC2 Instances
output "instance_ips" {
  description = "Public IP addresses of the public EC2 instances"
  value = {
    for i in aws_instance.this :
    i.id => {
      name       = i.tags["Name"]
      public_ip  = i.public_ip
      private_ip = i.private_ip
    }
  }
}