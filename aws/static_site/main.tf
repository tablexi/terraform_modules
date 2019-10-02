resource "aws_s3_bucket" "mod" {
  bucket = var.bucket_name
  acl    = "public-read"

  policy = jsonencode(
    {
      Id = "bucket_policy_site"
      Statement = [
        {
          Action = [
            "s3:GetObject",
          ]
          Effect    = "Allow"
          Principal = "*"
          Resource  = "arn:aws:s3:::${var.bucket_name}/*"
          Sid       = "bucket_policy_site_main"
        },
      ]
      Version = "2012-10-17"
    }
  )

  website {
    index_document = "${var.index_document}"
    error_document = "${var.index_document}"
  }
}

locals {
  s3_origin_id = "S3-${var.domain}"
}

resource "aws_cloudfront_distribution" "mod" {
  origin {
    domain_name = aws_s3_bucket.mod.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  aliases = [var.domain]

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "${var.index_document}"
  price_class         = "PriceClass_100"

  ordered_cache_behavior {
    path_pattern           = "static/*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${local.s3_origin_id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }

  // Allow for React Router to work using the vanity domains
  custom_error_response {
    error_caching_min_ttl = "300"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/"
  }

  custom_error_response {
    error_caching_min_ttl = "300"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/"
  }
}
