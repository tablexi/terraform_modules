data "aws_ami" "mod" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*x86_64-gp2"]
  }
}

resource "aws_instance" "mod" {
  count                       = "${var.count}"
  ami                         = "${var.ami != "" ? var.ami : data.aws_ami.mod.id}"
  instance_type               = "${var.type}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.security_group_on_instances.id}", "${var.vpc_security_group_ids}"]
  subnet_id                   = "${element(var.subnets, count.index)}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  disable_api_termination     = "${var.disable_api_termination}"

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

resource "aws_security_group_rule" "ssh_ingress_on_instances_from_anywhere" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.security_group_on_instances.id}"
  to_port           = 22
  type              = "ingress"
}
