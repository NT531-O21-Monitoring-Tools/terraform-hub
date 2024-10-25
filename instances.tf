# Create VPN Server
module "vpn_server"{
  source = "./modules/ec2"
  name            = "vpn-server"
  instance_type   = var.aws_instance_type
  subnets_id      = module.vpc.public_subnets
  sgs_id          = [module.vpn_server_sg.id]
  instance_count  = var.vpn_instance_count
  key_name        = module.keypair.key_name
}

# Create Monitoring Frontend Servers
module "monitoring_frontend_server" {
  source = "./modules/ec2"
  name            = "monitoring-frontend-server"
  instance_type   = var.aws_instance_type
  subnets_id      = [module.vpc.private_subnets[0]]
  sgs_id          = [module.monitoring_sg.id]
  instance_count  = var.monitoring_frontend_instance_count
  key_name        = module.keypair.key_name
}

# Create Monitoring Backend Servers
module "monitoring_backend_server" {
  source = "./modules/ec2"
  name            = "monitoring-backend-server"
  instance_type   = var.aws_instance_type
  subnets_id      = [module.vpc.private_subnets[0]]
  sgs_id          = [module.monitoring_sg.id]
  instance_count  = var.monitoring_backend_instance_count
  key_name        = module.keypair.key_name
}

# Create Apps (HA, Locust, Minikube) Servers
module "apps_server" {
  source = "./modules/ec2"
  name            = "apps-server"
  instance_type   = var.aws_instance_type
  subnets_id      = [module.vpc.private_subnets[1]]
  sgs_id          = [module.apps_sg.id]
  instance_count  = var.app_instance_count
  key_name        = module.keypair.key_name
}