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

variable "environment" {
  type = object({
    long = string
    short = string
  })
}

variable "node_group_extra_policies_arn" {
  type = list(string)
}

variable "eks_iam_users_arn" {
  type = list(string)
}