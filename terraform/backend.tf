terraform {
  backend "s3" {
    bucket         = "rajguptackt22-terraform-state"        #"your-terraform-state-bucket"
    key            = "" #This value is set according to environment stage using 'terraform init -backend-config="key=prod/terraform.tfstate" file.
    region         = "ap-south-1"
    encrypt        = true
  }
}