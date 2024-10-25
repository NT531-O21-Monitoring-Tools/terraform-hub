output "instances" {
  value = [
    module.vpn_server,
    module.monitoring_frontend_server,
    module.monitoring_backend_server,
    module.apps_server,
  ]
}

output "key_path" {
  value = module.keypair.private_key_path
}