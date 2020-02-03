resource "aws_route53_record" "cnames" {
  for_each = var.rules

  name    = each.key
  records = [var.load_balancer.dns_name]
  ttl     = 60
  type    = "CNAME"
  zone_id = var.dns_zone.id
}

resource "aws_lb_listener_rule" "http_redirects" {
  for_each     = var.rules
  listener_arn = var.load_balancer.http_listener_arn

  condition {
    host_header {
      values = [each.key]
    }
  }

  action {
    type = "redirect"
    redirect {
      host        = each.value["host"]
      path        = each.value["path"]
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "https_redirects" {
  for_each     = var.rules
  listener_arn = var.load_balancer.https_listener_arn

  condition {
    host_header {
      values = [each.key]
    }
  }

  action {
    type = "redirect"
    redirect {
      host        = each.value["host"]
      path        = each.value["path"]
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
