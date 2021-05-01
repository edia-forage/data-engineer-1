resource "google_project_iam_binding" "project" {
  project = "${var.project}"
  role    = "${var.role_name}"

  members = "${var.members}"

}