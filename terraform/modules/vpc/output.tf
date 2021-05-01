output "network" {
  value       = google_compute_network.network
  description = "The VPC resource being created"
}

output "network_name" {
  value       = google_compute_network.network.name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.network.self_link
  description = "The URI of the VPC being created"
}

output "sub_network_self_link" {
  value       = google_compute_subnetwork.network-with-private-secondary-ip-ranges.self_link
  description = "The URI of the sub network link being created"
}