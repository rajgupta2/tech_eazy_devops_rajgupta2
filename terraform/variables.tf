variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "ap-south-1"
}

variable "ami_value" {
  description = "value for the ami"
  type        = string
  default     = "ami-018046b953a698135"
}

variable "subnet_id_defaultVPC" {
  description = "value for the subnet id for default vpc"
  type        = string
  default     = "subnet-0850ced02e7902d56"
}
variable "instance_type_value" {
  description = "value for instance_type"
  type        = string
  default     = "t3.micro"
}

variable "key_name_value" {
  description = "name of pem file"
  type        = string
  default     = "new-key.pem"
}

# variable "s3_bucket_name" {
#   description = "Default AWS region for CLI configuration"
#   type        = string
#   default     = "raj-techeazy" # Replace with your desired bucket name
# }
