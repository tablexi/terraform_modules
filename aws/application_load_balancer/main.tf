locals {
  http_listener_port  = 80
  https_listener_port = 443

  prefix = "${var.name}-${var.environment}"
}

module "load_balancer" {
  source = "./load_balancer"

  access_logs_enabled = "${var.access_logs_enabled}"
  name                = "${local.prefix}"
  internal            = "${var.internal}"
  security_groups     = ["${aws_security_group.security_group_on_load_balancer.id}"]
  subnets             = ["${var.subnets}"]
}

resource "aws_security_group" "security_group_on_load_balancer" {
  name   = "${local.prefix}-alb"
  vpc_id = "${var.vpc_id}"

  ingress {
    cidr_blocks     = ["${var.ingress_cidr_blocks}"]
    from_port       = "${local.http_listener_port}"
    protocol        = "tcp"
    security_groups = ["${var.ingress_security_groups}"]
    to_port         = "${local.http_listener_port}"
  }

  ingress {
    cidr_blocks     = ["${var.ingress_cidr_blocks}"]
    from_port       = "${local.https_listener_port}"
    protocol        = "tcp"
    security_groups = ["${var.ingress_security_groups}"]
    to_port         = "${local.https_listener_port}"
  }

  egress {
    from_port       = 0
    protocol        = "tcp"
    security_groups = ["${var.security_group_for_instances}"]
    to_port         = 65535
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = "${module.load_balancer.arn}"
  port              = "${local.http_listener_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.http_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "http_target_group" {
  deregistration_delay = 30
  name                 = "${local.prefix}-http"
  port                 = "${var.http_target_group_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"

  health_check {
    matcher  = "${var.http_health_check_matcher}"
    path     = "${var.health_check_path}"
    port     = "${var.http_target_group_port}"
    protocol = "HTTP"
    timeout  = 5
  }
}

resource "aws_alb_target_group_attachment" "http_target_group_attachments" {
  count            = "${var.instances_count}"
  target_group_arn = "${aws_alb_target_group.http_target_group.arn}"
  target_id        = "${element(var.instances, count.index)}"
}

resource "aws_security_group_rule" "http_ingress_on_instances_from_load_balancer" {
  from_port                = "${var.http_target_group_port}"
  protocol                 = "tcp"
  security_group_id        = "${var.security_group_for_instances}"
  source_security_group_id = "${aws_security_group.security_group_on_load_balancer.id}"
  to_port                  = "${var.http_target_group_port}"
  type                     = "ingress"
}

resource "aws_alb_listener" "https_listener" {
  certificate_arn   = "${var.certificate_arn}"
  load_balancer_arn = "${module.load_balancer.arn}"
  port              = "${local.https_listener_port}"
  protocol          = "HTTPS"
  ssl_policy        = "${var.ssl_policy}"

  default_action {
    target_group_arn = "${var.https_target_group ? element(concat(aws_alb_target_group.https_target_group.*.arn, list("")), 0) : aws_alb_target_group.http_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "https_target_group" {
  count                = "${var.https_target_group ? 1 : 0}"
  deregistration_delay = 30
  name                 = "${local.prefix}-https"
  port                 = "${var.https_target_group_port}"
  protocol             = "HTTPS"
  vpc_id               = "${var.vpc_id}"

  health_check {
    matcher  = "${var.https_health_check_matcher}"
    path     = "${var.health_check_path}"
    port     = "${var.https_target_group_port}"
    protocol = "HTTPS"
    timeout  = 5
  }
}

resource "aws_alb_target_group_attachment" "https_target_group_attachments" {
  count            = "${var.https_target_group ? var.instances_count : 0}"
  target_group_arn = "${aws_alb_target_group.https_target_group.arn}"
  target_id        = "${element(var.instances, count.index)}"
}

resource "aws_security_group_rule" "https_ingress_on_instances_from_load_balancer" {
  count                    = "${var.https_target_group ? 1 : 0}"
  from_port                = "${var.https_target_group_port}"
  protocol                 = "tcp"
  security_group_id        = "${var.security_group_for_instances}"
  source_security_group_id = "${aws_security_group.security_group_on_load_balancer.id}"
  to_port                  = "${var.https_target_group_port}"
  type                     = "ingress"
}
