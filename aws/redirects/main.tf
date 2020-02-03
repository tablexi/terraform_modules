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
