resource "aws_route53_record" "aliases" {
  for_each = var.rules

  name    = join(".", compact([each.key, var.dns_zone.name]))
  type    = "A"
  zone_id = var.dns_zone.id

  alias {
    evaluate_target_health = false
    name                   = var.load_balancer.dns_name
    zone_id                = var.load_balancer.zone_id
  }
}

resource "aws_lb_listener_rule" "http_redirects" {
  for_each = var.rules

  listener_arn = var.load_balancer.http_listener_arn

  condition {
    host_header {
      values = [aws_route53_record.aliases[each.key].fqdn]
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
  for_each = var.rules

  listener_arn = var.load_balancer.https_listener_arn

  condition {
    host_header {
      values = [aws_route53_record.aliases[each.key].fqdn]
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
