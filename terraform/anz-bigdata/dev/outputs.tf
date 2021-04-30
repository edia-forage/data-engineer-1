output "network" {
  value = "${module.vpc.network}"
}

output "firewall_rule" {
  value = "${module.firewall.firewall_rule}"
}

output "external_ip" {
  value = "${module.http_server.external_ip}"
}