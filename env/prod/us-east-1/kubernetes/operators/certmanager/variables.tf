
variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = {
    long  = "development"
    short = "dev"
  }
}