resource "aws_cloudfront_distribution" "main" {

  origin_group {
    origin_id = "groupS3"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "primaryS3"
    }

    member {
      origin_id = "failoverS3"
    }
  }

  origin {
    origin_id   = "primaryS3"
    domain_name = aws_s3_bucket.website_s3_bucket.website_endpoint

    custom_origin_config {
      origin_protocol_policy = "http-only"

      http_port  = "80"
      https_port = "443"
      origin_ssl_protocols = ["TLSv1.2"]
    }

    custom_header {
      name  = "User-Agent"
      value = var.refer_secret
    }
  }

  
  origin {
    origin_id   = "failoverS3"
    domain_name = aws_s3_bucket.website_s3_bucket_failover.website_endpoint

    custom_origin_config {
      origin_protocol_policy = "http-only"

      http_port  = "80"
      https_port = "443"
      origin_ssl_protocols = ["TLSv1.2"]
    }

    custom_header {
      name  = "User-Agent"
      value = var.refer_secret
    }
  }

  enabled             = true
  default_root_object = var.index_document

  aliases = concat([var.fqdn], var.aliases)

  price_class = var.cloudfront_price_class

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.certificate_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  
  default_cache_behavior {
    target_origin_id = "groupS3"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 300
    max_ttl                = 1200
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}