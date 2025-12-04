
variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = {
    long  = "development"
    short = "dev"
  }
}


variable "tags" {
  description = "tags for resources"
  type = object({
    CreatedBy           = string
    Application         = string
    CostCenter          = string
    Contact             = string
    MaintenanceWindow   = string
    DeletionDate        = string
  })
}