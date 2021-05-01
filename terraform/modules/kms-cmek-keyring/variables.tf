variable "project_id" {
  description = "The project ID"
}

variable "key_ring_name" {
  description = "The key ring name"
  type = "string"
  default = "cloudStorage"
}

variable "bucket_region" {
  description = "The bucket region"
  default     = "asia-south1"
}