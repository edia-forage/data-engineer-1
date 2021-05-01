locals {
  env = "dev"
}

provider "google" {
  project = "${var.project}"
}

module "vpc" {
  source  = "../../modules/vpc"
  project = "${var.project}"
  env     = "${local.env}"
}

module "firewall" {
  source  = "../../modules/firewall"
  project = "${var.project}"
  network  = "${module.vpc.network_name}"
}

module "bucket_sa_account" {
  source = "../../modules/sa"
  project = "${var.project}"  
  sa_name = "ingestion-sa"
  sa_display_name = "sa for bucket access which stores ingested data"
}

module "gcs_bucket_kms_key_ring" {
  source                    = "../../modules/kms-cmek-keyring"
  project_id                = "${var.project}"
}

module "raw_bucket_request" {
  source                    = "../../modules/gcs-bucket"
  project_id                = "${var.project}"
  bucket_prefix             = "anz-raw"
  kms_key_ring              = "${module.gcs_bucket_kms_key_ring.cde_key_ring}"
}

module "transformed_bucket_request" {
  source                    = "../../modules/gcs-bucket"
  project_id                = "${var.project}"
  bucket_prefix             = "anz-transformed"
  kms_key_ring              = "${module.gcs_bucket_kms_key_ring.cde_key_ring}"
}

module "bucket_iam_ingestion_sa" {
  source                    = "../../modules/bucket-iam"
  bucket_name               = "${module.raw_bucket_request.bucket_name}"
  role_id                   = "roles/storage.admin"
  members                   = ["serviceAccount:${module.bucket_sa_account.sa_email}"]
}

module "bucket_iam_transformed_sa" {
  source                    = "../../modules/bucket-iam"
  role_id                   = "roles/storage.admin"
  bucket_name               = "${module.transformed_bucket_request.bucket_name}"
  members                   = ["serviceAccount:${module.bucket_sa_account.sa_email}"]
}

module "ingestion_sa_dataflow_role" {
  source                    = "../../modules/iam"
  project                   = "${var.project}"
  role_name                 = "roles/dataflow.worker"
  members                   = ["serviceAccount:${module.bucket_sa_account.sa_email}"]
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "serviceAccount:${var.cicd_sa}"
    ]
  }
}

resource "google_service_account_iam_policy" "admin-account-iam" {
  service_account_id = module.bucket_sa_account.sa_name
  policy_data        = data.google_iam_policy.admin.policy_data
}

module "data_flow_job1" {
  source                = "../../modules/dataflow"
  project_id            = var.project
  name                  = "wordcount-terraform-example"
  on_delete             = "cancel"
  max_workers           = 1
  template_gcs_path     = "gs://dataflow-templates/latest/Word_Count"
  temp_gcs_location     = module.transformed_bucket_request.bucket_name
  service_account_email = module.bucket_sa_account.sa_email
  network_self_link     = module.vpc.network_self_link
  subnetwork_self_link  = module.vpc.sub_network_self_link
  machine_type          = "n1-standard-1"

  parameters = {
    inputFile = "gs://anz-raw-anz-bigdata/shakespeare/kinglear.txt"
    output    = "gs://anz-transformed-anz-bigdata/output/my_output"
  }

  depends_on = [
    "google_service_account_iam_policy.admin-account-iam",
  ]
}
