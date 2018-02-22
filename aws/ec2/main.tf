data "aws_ami" "mod" {
  count = "${var.ami == "" ? 1 : 0}"
  most_recent = true

  filter {
    name = "name"
    values = ["amzn-ami-hvm-*x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "mod" {
  count = "${var.count}"
  ami = "${var.ami != "" ? var.ami : element(concat(data.aws_ami.mod.*.id, list("")), 0)}"
  instance_type = "${var.type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  subnet_id = "${element(var.subnets, count.index)}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  tags {
    Name = "${format("%s%02d", var.name, count.index + var.name_tag_starting_count)}"
    Environment = "${var.env}"
  }

  ebs_optimized = "${var.ebs_optimized}"
  root_block_device {
    volume_type = "${var.root_block_type}"
    volume_size = "${var.root_block_size}"
  }

  lifecycle {
    ignore_changes = [ "key_name" ]
  }
}

resource "aws_eip" "mod" {
  count = "${var.enable_eip ? var.count : 0}"
  instance = "${element(aws_instance.mod.*.id, count.index)}"
  vpc = true
}
