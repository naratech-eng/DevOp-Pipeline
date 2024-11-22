terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Provider configurations will go here
# Example:
# provider "aws" {
#   region = "us-west-2"
# }

provider "kubernetes" {
  # Kubeadm generated config
  config_path = var.kubernetes_config_path
  
  # If using a non-default context
  config_context = var.kubernetes_context
}

provider "helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
}

# Resource definitions will go here
