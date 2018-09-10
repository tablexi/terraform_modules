locals {
  version_major_minor_only = "${join(".", slice(split(".", var.engine_version), 0, 2))}"
}

locals {
  cluster_name = "${var.name}-${var.env}"
  family = "${var.engine}${local.version_major_minor_only}"
  parameter_group_name = "${var.parameter_group_name != "" ? var.parameter_group_name : "${local.cluster_name}-params${replace(local.version_major_minor_only, ".", "")}"}"
  port = "${var.port != "" ? var.port : "${var.engine == "redis" ? "6379" : "11211"}"}"
  elasticache_replication_group = "${(var.force_replication_group) || (var.num_nodes != 1)}"
}

resource "aws_elasticache_cluster" "mod" {
  count = "${local.elasticache_replication_group ? 0 : 1}"
  cluster_id = "${local.cluster_name}"
  num_cache_nodes = 1
  engine = "${var.engine}"
  engine_version = "${var.engine_version}"
  maintenance_window = "${var.maintenance_window}"
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
  at_rest_encryption_enabled = "${var.at_rest_encryption_enabled}"
  auto_minor_version_upgrade = true
  automatic_failover_enabled = "${var.automatic_failover_enabled}"
  count = "${local.elasticache_replication_group ? 1 : 0}"
  engine_version = "${var.engine_version}"
  maintenance_window = "${var.maintenance_window}"
  node_type = "${var.node_type}"
  number_cache_clusters = "${var.num_nodes}"
  parameter_group_name = "${aws_elasticache_parameter_group.mod.id}"
  port = "${local.port}"
  replication_group_description = "${var.name} ${var.env} ${var.engine} instance"
  replication_group_id = "${local.cluster_name}"
  security_group_ids = ["${aws_security_group.sg_on_elasticache_instance.id}"]
  subnet_group_name = "${aws_elasticache_subnet_group.mod.name}"
  transit_encryption_enabled = "${var.transit_encryption_enabled}"

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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_subnet_group" "mod" {
  name = "${local.cluster_name}-${var.engine}-subnet"
  description = "${local.cluster_name}-${var.engine}-subnet"
  subnet_ids = ["${var.subnets}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "sg_on_elasticache_instance" {
  name = "${var.engine}-${var.name}_${var.env}"
  description = "${var.engine} to ${var.name}_${var.env}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "${local.port}"
    to_port = "${local.port}"
    protocol = "tcp"
    security_groups = ["${var.security_groups_for_ingress}"]
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

  lifecycle {
    create_before_destroy = true
  }
}
