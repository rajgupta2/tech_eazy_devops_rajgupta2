output "public-ip-address-with-app-deployment" {
  description = "IP address of hosting server"
  value = aws_instance.webserver-techeazy.public_ip
}

output "Deploying" {
  description = "Deploying the application"
  value       = "Please wait upto 2  minutes while setup our deployment server. As we are installing java, maven and git"
}
output "shutdown" {
  description = "shutdown msg"
  value       = "app will shutdown automatically according to user script after 20 minutes."
}