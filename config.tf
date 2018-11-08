# backend configuration is loaded in the Jenkinsfile init stage
terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

# this variable is set in the Jenkinsfile based on the git repository name
variable "env" {}

# locals must be used so ${var.env} can be interpolated in the definition
locals {
  tags = {
    Creator = "Terraform"
    Environment = "${var.env}"
    Owner = "my_team@my_company.com"
  }
}

variable "region" {
  default = "us-east-1"
}
