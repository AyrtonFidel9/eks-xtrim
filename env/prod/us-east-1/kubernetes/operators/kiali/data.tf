data "terraform_remote_state" "adu_eks" {
  backend = "s3"
  config = {
    bucket = "adu-infrastructure-us-east-1-dev"
    key    = "env/dev/us-east-1/kubernetes/eks/terraform.tfstate"
    region = "us-east-1"
  }
}