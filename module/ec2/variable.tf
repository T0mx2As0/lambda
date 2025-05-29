variable "ami" {
  type = string
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