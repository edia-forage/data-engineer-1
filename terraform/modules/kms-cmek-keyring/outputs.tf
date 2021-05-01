output "cde_key_ring" {
  value = "${google_kms_key_ring.key_ring.self_link}"
}

output "cde_key_ring_id" {
  value = "${google_kms_key_ring.key_ring.id}"
}