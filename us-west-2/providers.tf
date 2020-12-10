#Updated to use 0.13 best practice for provider version specifications
#(terraform.io/docs/configuration/provider-requirements.html#best-practices-for-provider-versions)

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.20"
    }
  }
}

provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "~/.aws/credentials"
}
