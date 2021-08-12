variable "hosted_zone_name" { 
  type = string 
}

variable "route53_zone_id" {
  type = string
}

variable "failover_bucket_name" {
  type = string
}

variable "fqdn" {
  type = string
  description = "The FQDN of the website and also name of the S3 bucket"
}

variable "aliases" {
  type = list(string)
  description = "Any other domain aliases to add to the CloudFront distribution"
  default = []
}

variable "force_destroy" {
  type = string
  description = "The force_destroy argument of the S3 bucket"
  default = "false"
}

variable "refer_secret" {
  type = string
  description = "A secret string to authenticate CF requests to S3"
}

variable "cloudfront_price_class" {
  type = string
  description = "PriceClass for CloudFront distribution"
  default = "PriceClass_100"
}

variable "index_document" {
  type = string
  default = "index.html"
}

variable "error_document" {
  type = string
  default = "404.html"
}

variable "error_response_code" {
  type = string
  default = "404"
}
