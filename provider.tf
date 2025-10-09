terraform {
  backend "s3" {
    bucket = "terraformstate536272"
    key    = "StateFileLambda"
    region = "eu-north-1"

  }
}

provider "aws" {
  #  alias  = "north"
  region = "eu-north-1"
}
