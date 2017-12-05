locals {
  lb_type_nickname = "${substr(var.type, 0, 1)}lb"
}

locals {
  sg_for_access_by_sgs_name = "${var.name}_${var.env}-${local.lb_type_nickname}"
  sg_on_lb_name = "${local.lb_type_nickname}-${var.name}_${var.env}"
}

resource "aws_lb" "mod" {
  name = "${var.name}"
  internal = "${var.internal}"
  load_balancer_type = "${var.type}"

  security_groups = [
    "${aws_security_group.sg_on_lb.id}"
  ]

  subnets = ["${var.subnets}"]

  tags {
    Name = "${var.name}"
    Environment = "${var.env}"
  }
}

resource "aws_security_group" "sg_for_access_by_sgs" {
  name = "${local.sg_for_access_by_sgs_name}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${local.sg_for_access_by_sgs_name}"
    Environment = "${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "sg_on_lb" {
  name = "${local.sg_on_lb_name}"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${local.sg_on_lb_name}"
    Environment = "${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_on_lb_egress" {
  security_group_id = "${aws_security_group.sg_on_lb.id}"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
