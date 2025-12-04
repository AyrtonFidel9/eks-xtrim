variable "cluster_name" {
  type = string
}

variable "cluster_ca" {
  type = string
}

variable "cluster_host" {
  type = string
}

variable "cluser_ae_role_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "node_groups_dep" {
  type = list(string)
}

variable "cluster_oidc_id" {
  type = string
}

variable "environment" {
  type = object({
    long = string
    short = string
  })
}

variable "tags" {
  description = "tags for resources"
  type = object({
    Description         = string
    CreatedBy           = string
    Application         = string
    CostCenter          = string
    Contact             = string
    MaintenanceWindow   = string
    DeletionDate        = string
  })
}