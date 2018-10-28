resource "aws_instance" "mod" {
  count                       = "${var.count}"
  ami                         = "${var.ami}"
  instance_type               = "${var.type}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.security_group_on_instances.id}", "${var.vpc_security_group_ids}"]
  subnet_id                   = "${element(var.subnets, count.index)}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  
  source_dest_check = "${var.source_dest_check}"

  tags {
    Name        = "${format("%s%02d", var.name, count.index + var.name_tag_starting_count)}"
    Environment = "${var.env}"
  }

  ebs_optimized = "${var.ebs_optimized}"

  root_block_device {
    volume_type = "${var.root_block_type}"
    volume_size = "${var.root_block_size}"
  }

  lifecycle {
    ignore_changes = ["key_name"]
  }
}

resource "aws_eip" "mod" {
  count    = "${var.enable_eip ? var.count : 0}"
  instance = "${element(aws_instance.mod.*.id, count.index)}"
  vpc      = true
}

resource "aws_security_group" "security_group_on_instances" {
  name   = "${var.name}-ec2-instances"
  vpc_id = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    "Name" = "${var.name}-ec2-instances"
  }
}

resource "aws_security_group_rule" "all_egress_on_instances_to_anywhere" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = -1
  security_group_id = "${aws_security_group.security_group_on_instances.id}"
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "all_ingress_on_instances_from_self" {
  from_port         = 0
  protocol          = -1
  security_group_id = "${aws_security_group.security_group_on_instances.id}"
  self              = true
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "ssh_ingress_on_instances_cidr_blocks" {
  count             = "${var.ssh_ingress_cidr_blocks_enable}"
  cidr_blocks       = ["${var.ssh_ingress_cidr_blocks}"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.security_group_on_instances.id}"
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "ssh_ingress_on_instances_sgs" {
  count                    = "${var.ssh_ingress_sgs_count}"
  source_security_group_id = "${element(var.ssh_ingress_sgs, count.index)}"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.security_group_on_instances.id}"
  to_port                  = 22
  type                     = "ingress"
}
