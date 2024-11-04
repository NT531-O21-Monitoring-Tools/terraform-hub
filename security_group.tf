# VPN Server Security Group
module "vpn_server_sg" {
  source      = "./modules/security_group"
  name        = "vpn-server"
  description = "Security group for HAProxy VPN Server"
  vpc_id      = module.vpc.vpc_id

  ingress_rules_with_cidr = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow OpenVPN Access"
      from_port   = 1194
      to_port     = 1194
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow SSH Access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
  ]

  egress_rules_with_cidr = [
    {
      description = "Allow all outbound traffic"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      ip          = "0.0.0.0/0"
    }
  ]
}

# Monitoring Security Group (Prometheus/Loki & Grafana/Icinga)
module "monitoring_sg" {
  source      = "./modules/security_group"
  name        = "${var.aws_project}-private"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for Monitoring"

  ingress_rules_with_security_group = [
    {
      description      = "Allow Prometheus Access"
      from_port        = 9090
      to_port          = 9090
      protocol         = "tcp"
      security_group_id = module.vpn_server_sg.id
    },
    {
      description      = "Allow Loki Access"
      from_port        = 3100
      to_port          = 3100
      protocol         = "tcp"
      security_group_id = module.vpn_server_sg.id
    },
    {
      description      = "Allow Grafana Web UI Access"
      from_port        = 3000
      to_port          = 3000
      protocol         = "tcp"
      security_group_id = module.vpn_server_sg.id
    },
    {
      description      = "Allow Monitoring Access"
      from_port        = 9100 # Node Exporter
      to_port          = 9100
      protocol         = "tcp"
      security_group_id = module.vpn_server_sg.id
    },
    {
      description      = "Allow Icinga Web UI Access"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      security_group_id = module.vpn_server_sg.id
    },
    {
      description       = "Allow Icinga API Access"
      from_port        = 5665
      to_port          = 5665
      protocol         = "tcp"
      security_group_id = module.vpn_server_sg.id
    },
    {
      description = "Allow SSH Access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      security_group_id = module.vpn_server_sg.id
    }
  ]
  egress_rules_with_cidr = [
    {
      protocol    = -1
      from_port   = -1
      to_port     = -1
      ip          = "0.0.0.0/0"
    },
  ]
}

# Server Applications Security Group (HA, Locust, Minikube)
module "apps_sg" {
  source      = "./modules/security_group"
  name        = "applications"
  description = "Security group for Applications"
  vpc_id      = module.vpc.vpc_id

  ingress_rules_with_security_group = [
    {
      description       = "Allow SSH Access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      security_group_id = module.vpn_server_sg.id
    },
  ]

  egress_rules_with_cidr = [
    {
      description = "Allow all outbound traffic"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      ip          = "0.0.0.0/0"
    }
  ]
}