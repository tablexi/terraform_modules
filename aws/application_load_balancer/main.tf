locals {
  http_listener_port  = 80
  https_listener_port = 443

  prefix = "${var.name}-${var.environment}"
}

module "load_balancer" {
  source = "./load_balancer"

  access_logs_enabled = var.access_logs_enabled
  name                = local.prefix
  internal            = var.internal
  security_groups     = [aws_security_group.security_group_on_load_balancer.id]
  subnets             = var.subnets

  tags = var.tags
}

resource "aws_security_group" "security_group_on_load_balancer" {
  name   = "${local.prefix}-alb"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks     = var.ingress_cidr_blocks
    from_port       = local.http_listener_port
    protocol        = "tcp"
    security_groups = var.ingress_security_groups
    to_port         = local.http_listener_port
  }

  ingress {
    cidr_blocks     = var.ingress_cidr_blocks
    from_port       = local.https_listener_port
    protocol        = "tcp"
    security_groups = var.ingress_security_groups
    to_port         = local.https_listener_port
  }

  egress {
    from_port       = 0
    protocol        = "tcp"
    security_groups = [var.security_group_for_instances]
    to_port         = 65535
  }

  tags = var.tags
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = module.load_balancer.arn
  port              = local.http_listener_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "redirect_domains_http" {
  count        = length(keys(var.redirect_domains))
  listener_arn = aws_alb_listener.http_listener.arn
  priority     = 500 + count.index

  action {
    type = "redirect"

    redirect {
      host        = element(values(var.redirect_domains), count.index)
      port        = var.redirect_http_to_https ? 443 : 80
      protocol    = var.redirect_http_to_https ? "HTTPS" : "HTTP"
      status_code = var.redirect_http_to_https_status_code
    }
  }

  condition {
    field  = "host-header"
    values = [element(keys(var.redirect_domains), count.index)]
  }
}

resource "aws_alb_listener_rule" "redirect_http_to_https" {
  count        = var.redirect_http_to_https ? 1 : 0
  listener_arn = aws_alb_listener.http_listener.arn
  priority     = 1000

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = var.redirect_http_to_https_status_code
    }
  }

  condition {
    field  = "path-pattern"
    values = ["*"]
  }
}

resource "aws_alb_listener" "https_listener" {
  certificate_arn   = var.certificate_arn
  load_balancer_arn = module.load_balancer.arn
  port              = local.https_listener_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "redirect_domains_https" {
  count        = length(keys(var.redirect_domains))
  listener_arn = aws_alb_listener.https_listener.arn
  priority     = 500 + count.index

  action {
    type = "redirect"

    redirect {
      host        = element(values(var.redirect_domains), count.index)
      status_code = var.redirect_http_to_https_status_code
    }
  }

  condition {
    field  = "host-header"
    values = [element(keys(var.redirect_domains), count.index)]
  }
}

resource "aws_alb_target_group" "target_group" {
  deregistration_delay = 30
  name                 = local.prefix
  port                 = var.target_group_port
  protocol             = var.target_group_protocol
  vpc_id               = var.vpc_id

  health_check {
    matcher  = var.health_check_matcher
    path     = var.health_check_path
    port     = var.target_group_port
    protocol = var.target_group_protocol
    timeout  = 5
  }

  tags = var.tags
}

resource "aws_alb_target_group_attachment" "target_group_attachments" {
  count            = length(var.instances)
  target_group_arn = aws_alb_target_group.target_group.arn
  target_id        = element(var.instances, count.index)
}

resource "aws_security_group_rule" "ingress_on_instances_from_load_balancer" {
  from_port                = var.target_group_port
  protocol                 = "tcp"
  security_group_id        = var.security_group_for_instances
  source_security_group_id = aws_security_group.security_group_on_load_balancer.id
  to_port                  = var.target_group_port
  type                     = "ingress"
}

