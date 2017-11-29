resource "aws_security_group" "mod" {
  name = "ssh-${var.env}"
  description = "ssh-${var.env}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.ingress_cidr_blocks}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.egress_cidr_blocks}"]
  }

  tags {
    "Name" = "ssh-${var.env}"
    "Environment" = "${var.env}"
  }
}
