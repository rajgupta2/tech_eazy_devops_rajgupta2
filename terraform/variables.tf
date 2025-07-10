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
variable "instance_name" {
  type = string
  default = "MyInstance-techeazyWithS3Access"
}
variable "stage" {
  description = "Deployment stage"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.stage)
    error_message = "Stage must be either 'dev' or 'prod'."
  }
}
variable "instance_name_s3_read" {
  type = string
  default = "InstanceWithS3ReadsAccess"
}
variable "key_name_value" {
  description = "name of pem file"
  type        = string
  default     = "new-key.pem"
}

variable "s3_bucket" {
  description = "The name of the S3 bucket"
  type        = string
  default = "logs-bucket-rajgupta2-ap-south-1"
  validation {
    condition = length(var.s3_bucket)>0
    error_message = "The bucket name must be provided and cannot be empty."
  }
}
variable "stop_after_minutes" {
  type = number
  default = 20
}