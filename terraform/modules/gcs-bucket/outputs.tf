output "ssl_bucket_name" {
  description = "Name of the created GCS bucket"
  value = "${google_storage_bucket.gcs_config_data_bucket.name}"
  #value = "${local.bucket_name}"
}

output "cde_crypto_key_id" {
  value = "${google_kms_crypto_key.crypto_key.id}"
}