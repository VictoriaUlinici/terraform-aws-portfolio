terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Configure your own remote backend here, e.g.:
  # backend "s3" {
  #   bucket = "my-terraform-state-bucket"
  #   key    = "reverse-proxy/terraform.tfstate"
  #   region = "eu-west-1"
  # }
  #
  # State is separated per environment via "terraform workspace", see README.md.
}
