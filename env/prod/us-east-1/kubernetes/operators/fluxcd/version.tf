terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.15.0"
    }

    gitlab = {
      source = "gitlabhq/gitlab"
      version = "18.5.0"
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
      version = "~> 1.14.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }

    flux = {
      source = "fluxcd/flux"
      version = "1.7.4"
    }

  }

  backend "s3" {
  }
}
