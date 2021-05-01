variable "project_id" {
  description = "The project ID"
}

variable "bucket_prefix" {
    description = "Prefix for bucket name"  
}

variable "kms_key_ring" {
  description = "Keyring for CMEK"
}

variable "rotation_period" {
  description = "This is crypto key rotation period"
  default     = "7776000s"
}

variable "bucket_region" {
  description = "The bucket region"
  default     = "asia-south1"
}

variable "confidentiality" {
  description = "Confidentiality Level for the bucket ('restricted', 'confidential', 'internal', 'public')"
  type        = "string"
  default     = "confidential"
}

variable "integrity"{
    description = "Integrity Level for the bucket ('uncontrolled', 'accurate', 'trusted', 'highlytrusted')"
    type = "string"
    default = "trusted"
}

variable "trustlevel"{
    description = "Trust Level for the bucket ('low', 'medium', 'high', 'veryhigh')"
    type = "string"
    default = "high"
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will restrict accidental deletion of bucket and objects"
  default     = true
}
variable "storage_class" {
  description = "The storagre class of bucket"
  default     = "REGIONAL"
}
variable "bucket_policy_only" {
  description = "Disable object permissions on bucket"
  default = true
}

