terraform {
  backend "gcs" {
    bucket = "anz-bigdata-tfstate"
    prefix = "env/dev"
  }
}