variable "additional_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    source      = string
    protocol    = string
    description = string
  }))
  default = []
}

variable "cluster_additional_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    source      = string
    protocol    = string
    description = string
  }))
  default = []
}


variable "vpc_id" {
  type = string
}

variable "environment" {
  type = object({
    long  = string
    short = string
  })
}


variable "tags" {
  description = "tags for resources"
  type = object({
    CreatedBy         = string
    Application       = string
    CostCenter        = string
    Contact           = string
    MaintenanceWindow = string
    DeletionDate      = string
  })
}
