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


