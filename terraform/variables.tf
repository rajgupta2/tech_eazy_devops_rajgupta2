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
  default = "TecheazyWithS3Access"
}
variable "stage" {
  description = "Deployment stage/environment (dev or prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.stage)
    error_message = "Stage must be either 'dev' or 'prod'."
  }
}
variable "key_name_value" {
  description = "name of pem file"
  type        = string
  default     = "new-key.pem"
}

variable "stop_after_minutes" {
  type = number
  default = 20
}
variable "github_token" {
  description = "GitHub token for accessing private repositories"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email address to receive SNS alerts"
  type        = string
  default     = "rajgupta.ckt.swe@gmail.com"
}