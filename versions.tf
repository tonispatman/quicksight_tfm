terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # To use remote state later, create a backend file (see backend_s3.tf.example)
  # backend "local" {}
}
