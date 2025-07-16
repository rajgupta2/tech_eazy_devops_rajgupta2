output "ec2-instance-profile" {
  description = "This is instance profile that we need to attach to 'EC2 having Hosting App'."
  value = aws_iam_instance_profile.ec2-instance-profile.name
}
output "s3_log_bucket" {
  description = "This is s3 bucket where we are storing app logs."
  value = var.s3_bucket
}

output "techeazy-security-group" {
  description = "This SG is assigned to EC2 having Hosting App"
  value = aws_security_group.techeazy-security-group.id
}

output "ip-of-instance-with-s3-read-access" {
  description = "IP address of s3-read server"
  value = aws_instance.webserver-techeazy-S3-read.public_ip
}

output "message" {
  description = "successfully created resources."
  value = "The Role, Policy, S3 Bucket, and EC2-Instance with S3 Read Role has been created successfully!"
}