# Create a key ring to use for cloud storage bucket encryption
resource "google_kms_key_ring" "key_ring" {
  project  = "${var.project_id}"
  name     = "${var.key_ring_name}"
  location = "${var.bucket_region}"
}