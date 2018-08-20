provider "aws" {
  alias = "source_region"
  region = "${var.source_db_region}"
}

provider "aws" {
  region = "${var.replica_db_region}"
}

data "aws_db_instance" "source_database" {
  db_instance_identifier = "${var.source_db}"

  provider = "aws.source_region"
}

locals {
  allocated_storage = "${data.aws_db_instance.source_database.allocated_storage}"
  engine = "${data.aws_db_instance.source_database.engine}"
  engine_version = "${var.engine_version != "" ? var.engine_version : data.aws_db_instance.source_database.engine_version}"
  storage_encrypted = "${data.aws_db_instance.source_database.storage_encrypted}"
  storage_type = "${data.aws_db_instance.source_database.storage_type}"

  major_engine_version = "${join(".", slice(split(".", local.engine_version), 0, 2))}"
  default_option_and_parameter_group_name = "${var.name}-${var.env}-${local.engine_nickname}${replace(local.major_engine_version, ".", "")}"

  engine_nickname = "${local.is_postgres ? "pg" : "mysql"}"
  family = "${local.engine}${local.major_engine_version}"
  is_postgres = "${local.engine == "postgres" ? true : false}"
  parameter_group_name = "${var.parameter_group_name != "" ? var.parameter_group_name : local.default_option_and_parameter_group_name}"
  port = "${local.is_postgres ? 5432 : 3306}"
  sg_on_rds_instance_name = "rds-${var.name}_${var.env}-${local.engine_nickname}"
}

resource "aws_db_parameter_group" "mod" {
  count = "${var.parameter_group_provided ? 0 : 1}"
  name = "${local.parameter_group_name}"
  family = "${local.family}"
  description = "${local.family} parameter group for ${var.name} ${var.env}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "mod" {
  identifier = "${var.identifier != "" ? var.identifier : "${var.name}-${var.env}-${local.engine}"}"
  replicate_source_db = "${data.aws_db_instance.source_database.id}"
  engine = "${local.engine}"
  engine_version = "${local.engine_version}"
  instance_class = "${var.node_type}"
  storage_type = "${local.storage_type}"
  allocated_storage = "${local.allocated_storage}"
  backup_retention_period = "${var.backup_retention_period}"
  multi_az = "${var.multi_az}"
  vpc_security_group_ids = ["${concat(var.vpc_security_group_ids, list(aws_security_group.sg_on_rds_instance.id))}"]
  parameter_group_name = "${local.parameter_group_name}"
  option_group_name = "${"default:${local.engine}-${replace(local.major_engine_version, ".", "-")}"}"
  final_snapshot_identifier = "${var.name}-${var.env}-${local.engine}-final-snapshot"
  skip_final_snapshot = "${var.skip_final_snapshot}"
  storage_encrypted = "${local.storage_encrypted}"
  publicly_accessible = "${var.publicly_accessible}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  allow_major_version_upgrade = true
  apply_immediately = true
}

resource "aws_security_group" "sg_on_rds_instance" {
  name = "${local.sg_on_rds_instance_name}"
  description = "${local.sg_on_rds_instance_name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "${local.port}"
    to_port = "${local.port}"
    protocol = "tcp"
    security_groups = ["${var.security_groups_for_ingress}"]
    cidr_blocks = ["${var.cidr_blocks_for_ingress}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Name" = "${local.sg_on_rds_instance_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
