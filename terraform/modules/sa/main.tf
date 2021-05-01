
resource "google_service_account" "sa_create" {	
  account_id   = "${var.sa_name}"	
  display_name = "${var.sa_display_name}"	
  project      = "${var.project}"	
}
