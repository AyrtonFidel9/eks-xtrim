terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.15.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "3.0.2"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.38.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "s3" {
  }
}
