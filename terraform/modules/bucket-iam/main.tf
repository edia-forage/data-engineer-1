resource "google_storage_bucket_iam_binding" "binding" {
  count   = "${var.set_iam_flag == "0" ? 0 : length(var.members) == 0 ? 0 : var.authoritative == "true" ? 1 : 0}"
  bucket  = "${var.bucket_name}"
  role    = "${var.role_id}"
  members = "${var.members}"
}

resource "google_storage_bucket_iam_member" "member" {
  count  = "${var.set_iam_flag == "0" ? 0 : length(var.members) == 0 ? 0 : var.authoritative == "false" ? length(var.members) : 0}"
  bucket = "${var.bucket_name}"
  role   = "${var.role_id}"
  member = "${element(var.members, count.index)}"
}
