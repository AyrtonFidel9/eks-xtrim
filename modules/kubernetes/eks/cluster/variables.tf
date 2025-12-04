variable "eks_iam_role_arn"{
  type = string
}

variable "subnet_ids" {
  type = list(string)
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

variable "users_allowed_to_manage_kms" {
  type = list(string)
}

variable "cluster_sg_id" {
  type = string
}


variable "eks_cluster_ae_role_arn" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "auth_mode" {
  type = string
  default = "API_AND_CONFIG_MAP"
}

variable "cluster_admin_users_permissions" {
  type = list(string)
}

variable "endpoint_public_access" {
  type = bool
  default = true
}

variable "bootstrap_cluster_creator_admin_permissions" {
  type = bool
  default = true
}

variable "cluster_logs" {
  type = list(string)
  default = []
}
