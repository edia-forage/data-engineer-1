output "network" {
  value = "${module.vpc.network}"
}

output "firewall_rule" {
  value = "${module.firewall.firewall_rule}"
}
