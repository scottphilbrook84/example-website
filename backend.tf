terraform {
  backend "s3" {
    encrypt                 = "true"
    bucket = "tf-backend-scott-us-east-1"
    key    = "us-east-1/website.tfstate"
    region = "us-east-1"
  }
}
