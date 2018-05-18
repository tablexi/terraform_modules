locals {
  access_logs_glacier_transition_days = 365

  http_deregistration_delay = 30
  http_health_check_matcher = "200,301"
  http_health_check_timeout = 5
  http_port_for_instances   = 80
  http_port_for_listener    = 80

  https_deregistration_delay = 30
  https_health_check_matcher = "200"
  https_health_check_timeout = 5
  https_port_for_instances   = 443
  https_port_for_listener    = 443

  name_prefix = "${var.name}-${var.environment}"
}

module "load_balancer" {
  source = "./load_balancer"

  access_logs_enabled = "${var.access_logs_enabled}"
  name                = "${local.name_prefix}"
  internal            = "${var.internal}"
  security_groups     = ["${aws_security_group.security_group_on_load_balancer.id}"]
  subnets             = ["${var.subnets}"]
}

resource "aws_security_group" "security_group_on_load_balancer" {
  name   = "${local.name_prefix}-alb"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port       = "${local.http_port_for_instances}"
    protocol        = "tcp"
    security_groups = ["${var.security_group_for_instances}"]
    to_port         = "${local.http_port_for_instances}"
  }

  egress {
    from_port       = "${local.https_port_for_instances}"
    protocol        = "tcp"
    security_groups = ["${var.security_group_for_instances}"]
    to_port         = "${local.https_port_for_instances}"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "${local.http_port_for_listener}"
    protocol    = "tcp"
    to_port     = "${local.http_port_for_listener}"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "${local.https_port_for_listener}"
    protocol    = "tcp"
    to_port     = "${local.https_port_for_listener}"
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = "${module.load_balancer.arn}"
  port              = "${local.http_port_for_listener}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.http_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "http_target_group" {
  deregistration_delay = "${local.http_deregistration_delay}"
  name                 = "${local.name_prefix}-http"
  port                 = "${local.http_port_for_instances}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"

  health_check {
    matcher  = "${local.http_health_check_matcher}"
    path     = "${var.health_check_path}"
    port     = "${local.http_port_for_instances}"
    protocol = "HTTP"
    timeout  = "${local.http_health_check_timeout}"
  }
}

resource "aws_alb_target_group_attachment" "http_target_group_attachments" {
  count            = "${var.instances_count}"
  target_group_arn = "${aws_alb_target_group.http_target_group.arn}"
  target_id        = "${element(var.instances, count.index)}"
}

resource "aws_security_group_rule" "http_ingress_on_instances_from_load_balancer" {
  from_port                = "${local.http_port_for_instances}"
  protocol                 = "tcp"
  security_group_id        = "${var.security_group_for_instances}"
  source_security_group_id = "${aws_security_group.security_group_on_load_balancer.id}"
  to_port                  = "${local.http_port_for_instances}"
  type                     = "ingress"
}

resource "aws_alb_listener" "https_listener" {
  certificate_arn   = "${var.certificate_arn}"
  load_balancer_arn = "${module.load_balancer.arn}"
  port              = "${local.https_port_for_listener}"
  protocol          = "HTTPS"
  ssl_policy        = "${var.ssl_policy}"

  default_action {
    target_group_arn = "${aws_alb_target_group.http_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "https_target_group" {
  deregistration_delay = "${local.https_deregistration_delay}"
  name                 = "${local.name_prefix}-https"
  port                 = "${local.https_port_for_instances}"
  protocol             = "HTTPS"
  vpc_id               = "${var.vpc_id}"

  health_check {
    matcher  = "${local.https_health_check_matcher}"
    path     = "${var.health_check_path}"
    port     = "${local.https_port_for_instances}"
    protocol = "HTTPS"
    timeout  = "${local.https_health_check_timeout}"
  }
}

resource "aws_alb_target_group_attachment" "https_target_group_attachments" {
  count            = "${var.instances_count}"
  target_group_arn = "${aws_alb_target_group.https_target_group.arn}"
  target_id        = "${element(var.instances, count.index)}"
}

resource "aws_security_group_rule" "https_ingress_on_instances_from_load_balancer" {
  from_port                = "${local.https_port_for_instances}"
  protocol                 = "tcp"
  security_group_id        = "${var.security_group_for_instances}"
  source_security_group_id = "${aws_security_group.security_group_on_load_balancer.id}"
  to_port                  = "${local.https_port_for_instances}"
  type                     = "ingress"
}
