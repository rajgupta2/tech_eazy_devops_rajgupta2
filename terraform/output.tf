output "public-ip-address-with-app-deployment" {
  description = "IP address of hosting server"
  value = aws_instance.webserver-techeazy.public_ip
}

output "ip-address-instance-with-s3-read-access" {
  description = "IP address of s3-read server"
  value = aws_instance.webserver-techeazy-S3-read.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.webserver-techeazy.id
}
output "Deploying" {
  description = "Deploying the application"
  value       = "Please wait upto 2  minutes while setup our deployment server. As we are installing java, maven and git"
}
output "shutdown" {
  description = "shutdown msg"
  value       = "app will shutdown automatically according to user script after 20 minutes."
}