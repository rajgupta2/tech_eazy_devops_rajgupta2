terraform {
  backend "s3" {
    bucket         = "rajguptackt22-terraform-state"        #"your-terraform-state-bucket"
    key            = "shared/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}