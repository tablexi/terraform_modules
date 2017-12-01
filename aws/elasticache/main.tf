locals {
  version_major_minor_only = "${join(".", slice(split(".", var.engine_version), 0, 2))}"
}

locals {
  cluster_name = "${var.name}-${var.env}"
  family = "${var.engine}${local.version_major_minor_only}"
  parameter_group_name = "${var.parameter_group_name != "" ? var.parameter_group_name : "${local.cluster_name}-params"}"
  port = "${var.port != "" ? var.port : "${var.engine == "redis" ? "6379" : "11211"}"}"
}

resource "aws_elasticache_cluster" "mod" {
  count = "${(var.num_nodes == 1) ? 1 : 0}"
  cluster_id = "${local.cluster_name}"
  num_cache_nodes = 1
  engine = "${var.engine}"
  engine_version = "${var.engine_version}"
  node_type = "${var.node_type}"
  port = "${local.port}"
  parameter_group_name = "${local.parameter_group_name}"
  security_group_ids = ["${aws_security_group.sg_on_elasticache_instance.id}"]
  subnet_group_name = "${aws_elasticache_subnet_group.mod.name}"
  tags = {
    Environment = "${var.env}"
    Description = "${var.name} ${var.env} ${var.engine} instance"
  }
}

resource "aws_elasticache_replication_group" "mod" {
  count = "${(var.num_nodes != 1) ? 1 : 0}"
  replication_group_id = "${local.cluster_name}"
  replication_group_description = "${var.name} ${var.env} ${var.engine} instance"
  number_cache_clusters = "${var.num_nodes}"
  engine_version = "${var.engine_version}"
  auto_minor_version_upgrade = true
  node_type = "${var.node_type}"
  port = "${local.port}"
  parameter_group_name = "${aws_elasticache_parameter_group.mod.id}"
  security_group_ids = ["${aws_security_group.sg_on_elasticache_instance.id}"]
  subnet_group_name = "${aws_elasticache_subnet_group.mod.name}"
  tags = {
    Environment = "${var.env}"
    Description = "${var.name} ${var.env} ${var.engine} instance"
  }
}

resource "aws_elasticache_parameter_group" "mod" {
  count = "${var.create_parameter_group ? 1 : 0}"
  name = "${local.parameter_group_name}"
  family = "${local.family}"
  description = "${var.name} ${var.env} env ${var.engine} cluster param group"
}

resource "aws_elasticache_subnet_group" "mod" {
  name = "${local.cluster_name}-${var.engine}-subnet"
  description = "${local.cluster_name}-${var.engine}-subnet"
  subnet_ids = ["${var.subnets}"]
}

resource "aws_security_group" "sg_for_access_by_sgs" {
  name = "${var.env}-${var.engine}"
  description = "${var.env} to ${var.engine}"
  vpc_id = "${var.vpc_id}"

  tags {
    "Name" = "${var.env}-${var.engine}"
  }
}

resource "aws_security_group" "sg_on_elasticache_instance" {
  name = "${var.engine}-${var.env}"
  description = "${var.engine} to ${var.env}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "${local.port}"
    to_port = "${local.port}"
    protocol = "tcp"
    security_groups = ["${aws_security_group.sg_for_access_by_sgs.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Name" = "${var.engine}-${var.env}"
  }
}
