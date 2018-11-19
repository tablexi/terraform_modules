locals {
  engine_nickname         = "${local.is_postgres ? "pg" : "mysql"}"
  family                  = "${var.engine}${var.engine_version}"
  is_postgres             = "${var.engine == "postgres" ? true : false}"
  parameter_group_name    = "${var.parameter_group_name != "" ? var.parameter_group_name : "${var.name}-${var.env}-${local.engine_nickname}${replace(var.engine_version, ".", "")}"}"
  port                    = "${local.is_postgres ? 5432 : 3306}"
  sg_on_rds_instance_name = "rds-${var.name}_${var.env}-${local.engine_nickname}"
  subnet_group_name       = "${var.subnet_group_name != "" ? var.subnet_group_name : "${var.name}-${var.env}-${local.engine_nickname}-sg"}"
}

resource "aws_db_subnet_group" "mod" {
  count       = "${var.create_db_subnet_group ? 1 : 0}"
  name        = "${local.subnet_group_name}"
  description = "${var.name} ${var.env} db ${var.engine} subnet group"
  subnet_ids  = ["${var.subnets}"]

  lifecycle {
    create_before_destroy = true

    # Apparently subnet groups cannot be changed within the same VPC. Even
    # though the AWS documentation says otherwise.
    # http://serverfault.com/a/817598
    ignore_changes = ["name"]
  }
}

resource "aws_db_parameter_group" "mod" {
  count       = "${var.parameter_group_provided ? 0 : 1}"
  name        = "${local.parameter_group_name}"
  family      = "${local.family}"
  description = "${local.family} parameter group for ${var.name} ${var.env}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "mod" {
  identifier                  = "${var.identifier != "" ? var.identifier : "${var.name}-${var.env}-${var.engine}"}"
  replicate_source_db         = "${var.source_db}"
  engine                      = "${var.engine}"
  engine_version              = "${var.engine_version}"
  instance_class              = "${var.node_type}"
  storage_type                = "${var.storage_type}"
  allocated_storage           = "${var.storage}"
  username                    = "${var.username != "" ? var.username : "${var.name}${var.username_suffix}"}"
  password                    = "nopassword"
  backup_retention_period     = "${var.backup_retention_period}"
  multi_az                    = "${var.multi_az}"
  vpc_security_group_ids      = ["${concat(var.vpc_security_group_ids, list(aws_security_group.sg_on_rds_instance.id))}"]
  db_subnet_group_name        = "${var.source_db == "" ? local.subnet_group_name : ""}"
  parameter_group_name        = "${local.parameter_group_name}"
  option_group_name           = "${"default:${var.engine}-${replace(var.engine_version, ".", "-")}"}"
  final_snapshot_identifier   = "${var.name}-${var.env}-${var.engine}-final-snapshot"
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  storage_encrypted           = "${var.storage_encrypted}"
  kms_key_id                  = "${var.kms_key_id}"
  publicly_accessible         = "${var.publicly_accessible}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  allow_major_version_upgrade = true
  apply_immediately           = true
}

resource "aws_security_group" "sg_on_rds_instance" {
  name        = "${local.sg_on_rds_instance_name}"
  description = "${local.sg_on_rds_instance_name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${local.port}"
    to_port         = "${local.port}"
    protocol        = "tcp"
    security_groups = ["${var.security_groups_for_ingress}"]
    cidr_blocks     = ["${var.sg_cidr_blocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Name" = "${local.sg_on_rds_instance_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
