# Provider.tf File
provider "aws" {
  access_key = ""
  secret_key = ""
  region = "${var.AWS_REGION}"
}
