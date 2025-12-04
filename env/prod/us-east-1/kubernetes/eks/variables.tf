variable "users_arn" {
  type = list(string)
}

variable "node_group_extra_policies_arn" {
  type = list(string)
}

variable "addons" {
  type = list(object({
    name              = string
    version           = string
    resolve_conflicts = string
  }))
}

variable "endpoint_public_access" {
  type = bool
}

variable "node_groups" {
  type = list(object({
    name                 = string
    instance_types       = list(string)
    capacity_type        = string
    ami_type             = string
    disk_size            = number
    scaling_desired_size = number
    scaling_max_size     = number
    scaling_min_size     = number
    max_unavailable      = number
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    release_version = string
    custom_tags     = map(string)
  }))
}

variable "cluster_version" {
  type = string
}
variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = {
    long  = "prodelopment"
    short = "prod"
  }
}

variable "users_allowed_to_manage_kms" {
  type = list(string)
}

variable "cluster_admin_users_permissions" {
  type = list(string)
}


variable "created_by" {
  description = "Person who created the resource"
}

variable "application" {
  description = "The service or application of which the resource is a component"
}

variable "cost_center" {
  description = "Useful for billing center (Human Resources | IT department)"
}

variable "contact" {
  description = "email address for the team or individual"
}

variable "maintenance_window" {
  description = "Useful for defining a window of time that resource is allows to not be available in case of parching, updates, or maintance"
}

variable "deletion_date" {
  description = "Useful for prodelopment or sandbox environments so that you know when it may be safe to delete a resource"
}
