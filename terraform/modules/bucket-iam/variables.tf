variable set_iam_flag {
  description = "Flag to determine if iam changes should run.  Must be '0' or '1'.  Enables selective deployment of connection objects."
  default     = "1"
}

variable bucket_name {}

variable role_id {
  default = ""
}

variable members {
  # If this members variable is the empty list then the resource won't get created.
  type    = "list"
  default = []
}

variable authoritative {
  default     = "true"
  description = "If True will overwrite all IAM policies on the given bucket. See See https://www.terraform.io/docs/providers/google/r/storage_bucket_iam.html"
}


