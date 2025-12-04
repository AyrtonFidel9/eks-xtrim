mock_provider "terraform" {
  override_data {
    target = data.terraform_remote_state.xtrim_network
    values = {
      outputs = {
        vpc_id = "vpc-0abc123456789def0"

        subnets = [
          {
            id = "subnet-0abc1234a1a1a1a1a"
            tags = {
              SubnetType = "private"
            }
          },
          {
            id = "subnet-0def5678b2b2b2b2b"
            tags = {
              SubnetType = "public"
            }
          }
        ]
      }
    }
  }
  override_data {
    target = data.terraform_remote_state.vpn
    values = {
      outputs = {
        ec2_security_group_id = "sg-0abc1234def567890"
      }
    }
  }
}




run "plan" {
  providers = {
    terraform = terraform
  }
  command = plan
}