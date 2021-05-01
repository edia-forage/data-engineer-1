output "sa_name" {
  value = "${google_service_account.sa_create.name}"
}

output "sa_email" {
  value = "${google_service_account.sa_create.email}"
}
