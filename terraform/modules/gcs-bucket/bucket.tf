locals {
  bucket_name = "${var.bucket_prefix}-${var.project_id}"
}

resource "google_storage_bucket" "gcs_config_data_bucket" {
  project       = "${var.project_id}"
  name          = "${local.bucket_name}"
  location      = "${var.bucket_region}"
  force_destroy = "${var.force_destroy}"
  storage_class = "${var.storage_class}"
  bucket_policy_only = "${var.bucket_policy_only}"

  labels = {
      confidentiality = "${var.confidentiality}"
      integrity = "${var.integrity}"
      trustlevel = "${var.trustlevel}"
  }

  encryption {
      default_kms_key_name = "${join("", google_kms_crypto_key_iam_member.gcs_access_to_key.*.crypto_key_id)}"
  }

}

