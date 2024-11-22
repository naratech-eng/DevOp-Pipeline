terraform {
  required_version = ">= 1.0.0"
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Provider configurations will go here
# Example:
# provider "aws" {
#   region = "us-west-2"
# }

# Resource definitions will go here
