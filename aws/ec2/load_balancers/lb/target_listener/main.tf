locals {
  default_health_check = {
    interval = 30
    path = "/"
    port = "${var.port}"
    protocol = "${var.protocol}"
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
    matcher = "200"
  }
}

locals {
  health_check = "${merge(local.default_health_check, var.health_check)}"
}

resource "aws_lb_target_group" "mod" {
  name = "${var.name}"
  port = "${var.port}"
  protocol = "${var.protocol}"
  vpc_id = "${var.vpc_id}"

  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    interval = "${local.health_check["interval"]}"
    path = "${local.health_check["path"]}"
    port = "${local.health_check["port"]}"
    protocol = "${local.health_check["protocol"]}"
    timeout = "${local.health_check["timeout"]}"
    healthy_threshold = "${local.health_check["healthy_threshold"]}"
    unhealthy_threshold = "${local.health_check["unhealthy_threshold"]}"
    matcher = "${local.health_check["matcher"]}"
  }
}

resource "aws_lb_target_group_attachment" "mod" {
  count = "${var.target_id_count}"
  target_group_arn = "${aws_lb_target_group.mod.arn}"
  target_id = "${element(var.target_ids, count.index)}"
  port = "${var.port}"
}

resource "aws_lb_listener" "mod" {
  load_balancer_arn = "${var.lb_arn}"
  port = "${var.port}"
  protocol = "${var.protocol}"
  ssl_policy = "${var.protocol == "HTTPS" ? var.ssl_policy : ""}"
  certificate_arn =  "${var.protocol == "HTTPS" ? var.certificate_arn : ""}"

  default_action {
    target_group_arn = "${aws_lb_target_group.mod.arn}"
    type = "forward"
  }
}

resource "aws_security_group_rule" "mod_sg_for_access_by_sgs" {
  security_group_id = "${var.sg_for_access_by_sgs_id}"
  type = "ingress"
  from_port = "${var.port}"
  to_port = "${var.port}"
  protocol = "tcp"
  source_security_group_id = "${var.sg_on_lb_id}"
}

resource "aws_security_group_rule" "mod_sg_on_lb_cidr_blocks" {
  count = "${length(var.sg_on_lb_cidr_blocks) > 0 ? 1 : 0}"
  security_group_id = "${var.sg_on_lb_id}"
  type = "ingress"
  from_port = "${var.port}"
  to_port = "${var.port}"
  protocol = "tcp"
  cidr_blocks = ["${var.sg_on_lb_cidr_blocks}"]
}

resource "aws_security_group_rule" "mod_sg_on_lb_security_groups" {
  count = "${length(var.sg_on_lb_source_ids) > 0 ? length(var.sg_on_lb_source_ids) : 0}"
  security_group_id = "${var.sg_on_lb_id}"
  type = "ingress"
  from_port = "${var.port}"
  to_port = "${var.port}"
  protocol = "tcp"
  source_security_group_id = "${element(var.sg_on_lb_source_ids, count.index)}"
}
