terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "My_0rGan1ZaTi0N"

    workspaces {
      name = "lambda"
    }
  }
}

provider "aws" {
  #  alias  = "north"
  region = "eu-north-1"
  #  access_key = var.access_key
  #  secret_key = var.secret_key
}
