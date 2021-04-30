resource "google_compute_network" "network" {
  name                            = "${var.env}"
  auto_create_subnetworks         = "${var.auto_create_subnetworks}"
  routing_mode                    = "${var.routing_mode}"
  project                         = "${var.project}"
  description                     = "${var.description}"
  delete_default_routes_on_create = "${var.delete_default_internet_gateway_routes}"
  mtu                             = "${var.mtu}"
}

/******************************************
	Shared VPC
 *****************************************/
resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  provider = google-beta

  project    = "${var.project}"
  depends_on = [google_compute_network.network]
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "${var.env}-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "asia-south1"
  network       = google_compute_network.network.id
  secondary_ip_range {
    range_name    = "tf-${var.env}-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}