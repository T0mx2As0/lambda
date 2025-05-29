
data "aws_ssm_parameter" "ami" {
  name = "image-ami"
}
variable "instance_type" {
  type = string
}
data "http" "my_ip" { # my public IP
  url = "https://ipv4.icanhazip.com"
}
variable "key_name" {
  type = string
}


variable "secret_key" {
  type = string
}

variable "access_key" {
  type = string
}