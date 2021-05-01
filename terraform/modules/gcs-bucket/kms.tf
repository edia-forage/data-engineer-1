resource "google_kms_crypto_key" "crypto_key" {
  name            = "${local.bucket_name}_key"
  key_ring        = "${var.kms_key_ring}"
  rotation_period = "${var.rotation_period}"

  labels = {
    confidentiality = "${var.confidentiality}"
    integrity       = "${var.integrity}"
    securityzone    = "${var.trustlevel}"
  }
  
  lifecycle {
      prevent_destroy = true
  }
}

data "google_storage_project_service_account" "gcs_account" {
  project = "${var.project_id}"
}

resource "google_kms_crypto_key_iam_member" "gcs_access_to_key" {
  crypto_key_id = "${join("", google_kms_crypto_key.crypto_key.*.self_link)}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}