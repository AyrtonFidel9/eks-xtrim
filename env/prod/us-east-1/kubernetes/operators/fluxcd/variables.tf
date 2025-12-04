
variable "region" {
  default = "us-east-1"
}

variable "token" {
  type = string
  default = "glpat-DxtEIIuiBydD4icfqCM1QW86MQp1OmRqOHowCw.01.120ihtg86"
  sensitive   = true
}

variable "adu_gitlab_repository" {
  type = string
  default = "ssh://git@gitlab.com/workersbenefitfund/adu-infrastructure.git"
}

variable "env" {
  default = {
    long  = "development"
    short = "dev"
  }
}