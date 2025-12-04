
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "terraform_remote_state" "xtrim_network" {
  backend = "s3"
  config = {
    bucket = "xtrim-infrastructure-us-east-1-prod"
    key    = "env/prod/us-east-1/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# data "terraform_remote_state" "vpn" {
#   backend = "s3"
#   config = {
#     bucket = "xtrim-infrastructure-us-east-1-prod"
#     key    = "env/prod/us-east-1/vpn/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

data "aws_kms_key" "ebs_by_id" {
  key_id = "604d9ca9-7a56-4a9f-bfcf-c52108e4d6bd"
}
