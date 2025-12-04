variable "cluster_name" {
  type = string
}

variable "addons" {
  type = list(object({
    name              = string
    version           = string
    resolve_conflicts = string
  }))
}

variable "openid_arn" {
  type = string
}

variable "openid_url" {
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