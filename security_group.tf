# VPN Server Security Group
module "bastion_sg" {
  source      = "./modules/security_group"
  name        = "${var.aws_project}-bastion_sg"
  description = "Security group for bastion instance"
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
      protocol    = "udp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Node Exporter Access"
      from_port   = 9100 # Node Exporter
      to_port     = 9100
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
    {
      description = "Allow ICMP Access"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      ip          = "0.0.0.0/0"
    }
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
  name        = "${var.aws_project}-monitoring_sg"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for Monitoring"

  ingress_rules_with_cidr = [
    {
      description = "Allow ICMP Access"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Icinga Web UI Access"
      from_port   = 80
      to_port     = 80
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
    {
      description = "Allow Node Exporter Access"
      from_port   = 9100 # Node Exporter
      to_port     = 9100
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Prometheus Access"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Loki Access"
      from_port   = 3100
      to_port     = 3100
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Promtail Access"
      from_port   = 9080
      to_port     = 9080
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Grafana Web UI Access"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Icinga API Access"
      from_port   = 5665
      to_port     = 5665
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    }
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

# Server Applications Security Group (HA, Locust, Minikube)
module "cluster_sg" {
  source      = "./modules/security_group"
  name        = "${var.aws_project}-cluster_sg"
  description = "Security group for Applications"
  vpc_id      = module.vpc.vpc_id

  ingress_rules_with_cidr = [ 
    {
      description = "Allow ICMP Access"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow SSH Access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Node Exporter Access"
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Prometheus Access"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Loki Access"
      from_port   = 3100
      to_port     = 3100
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "K3s supervisor and Kubernetes API Server"
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Kubelet metrics"
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow all traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      ip          = "0.0.0.0/0"
    }
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