terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

resource "aws_instance" "webserver-techeazy" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  subnet_id              = var.subnet_id_defaultVPC
  iam_instance_profile   = data.terraform_remote_state.shared_role.outputs.ec2-instance-profile
  associate_public_ip_address = true
  vpc_security_group_ids = [data.terraform_remote_state.shared_role.outputs.techeazy-security-group]
  user_data = base64encode(templatefile("../scripts/${var.stage}_script.sh",{
    STOP_INSTANCE       = var.stop_after_minutes # Match STOP_INSTANCE in script
    S3_BUCKET_NAME      = data.terraform_remote_state.shared_role.outputs.s3_log_bucket
    GITHUB_TOKEN        = var.github_token
  }))
  tags = {
    Name = "${var.instance_name}-${var.stage}"
  }
  depends_on = [ data.terraform_remote_state.shared_role ]
}

data "terraform_remote_state" "shared_role" {
  backend = "s3"
  config = {
    bucket = "rajguptackt22-terraform-state"
    key    = "shared/terraform.tfstate"
    region = "ap-south-1"
  }
}