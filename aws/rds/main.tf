locals {
  engine_nickname             = local.is_postgres ? "pg" : "mysql"
  family                      = "${var.engine}${var.engine_version}"
  is_postgres                 = var.engine == "postgres" ? true : false
  major_engine_version_return = length(split(".", var.engine_version)) > 1 ? 2 : 1
  parameter_group_name        = var.parameter_group_name != "" ? var.parameter_group_name : "default.${var.engine}${local.major_engine_version}"
  port                        = local.is_postgres ? 5432 : 3306
  sg_on_rds_instance_name     = "rds-${var.name}_${var.env}-${local.engine_nickname}"
  subnet_group_name           = var.subnet_group_name != "" ? var.subnet_group_name : "${var.name}-${var.env}-${local.engine_nickname}-sg"
  txi_cidr_blocks             = ["199.182.213.26/32", "66.115.191.74/32"]

  major_engine_version = join(
    ".",
    slice(
      split(".", var.engine_version),
      0,
      local.major_engine_version_return,
    ),
  )
}

resource "aws_db_subnet_group" "mod" {
  count       = var.create_db_subnet_group ? 1 : 0
  description = "${var.name} ${var.env} db ${var.engine} subnet group"
  name        = local.subnet_group_name
  subnet_ids  = var.subnets
  tags        = var.tags

  lifecycle {
    create_before_destroy = true

    # Apparently subnet groups cannot be changed within the same VPC. Even
    # though the AWS documentation says otherwise.
    # http://serverfault.com/a/817598
    ignore_changes = [name]
  }
}

resource "aws_db_instance" "mod" {
  allocated_storage           = var.storage
  allow_major_version_upgrade = true
  apply_immediately           = true
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  backup_retention_period     = var.backup_retention_period
  db_subnet_group_name        = var.source_db == "" ? local.subnet_group_name : ""
  engine                      = var.engine
  engine_version              = var.engine_version
  final_snapshot_identifier   = "${var.name}-${var.env}-${var.engine}-final-snapshot"
  identifier                  = var.identifier != "" ? var.identifier : "${var.name}-${var.env}-${var.engine}"
  iops                        = var.iops
  instance_class              = var.node_type
  kms_key_id                  = var.kms_key_id
  monitoring_interval         = var.monitoring_interval
  monitoring_role_arn         = var.monitoring_interval == 0 ? "" : aws_iam_role.rds_enhanced_monitoring[0].arn
  multi_az                    = var.multi_az
  parameter_group_name        = local.parameter_group_name
  password                    = "nopassword"
  publicly_accessible         = var.publicly_accessible
  replicate_source_db         = var.source_db
  skip_final_snapshot         = var.skip_final_snapshot
  storage_encrypted           = var.storage_encrypted
  storage_type                = var.storage_type
  tags                        = var.tags
  username                    = var.username != "" ? var.username : "${var.name}${var.username_suffix}"

  vpc_security_group_ids = concat(
    var.vpc_security_group_ids,
    [aws_security_group.sg_on_rds_instance.id],
  )
}

resource "aws_security_group" "sg_on_rds_instance" {
  description = local.sg_on_rds_instance_name
  name        = local.sg_on_rds_instance_name
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks     = var.expose_to_txi_office ? concat(local.txi_cidr_blocks, var.sg_cidr_blocks) : var.sg_cidr_blocks
    from_port       = local.port
    protocol        = "tcp"
    security_groups = var.security_groups_for_ingress
    to_port         = local.port
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = merge(
    {
      "Name" = local.sg_on_rds_instance_name
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring[0].json
  count              = var.monitoring_interval == 0 ? 0 : 1
  name_prefix        = "rds-enhanced-monitoring"
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count      = var.monitoring_interval == 0 ? 0 : 1
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  count = var.monitoring_interval == 0 ? 0 : 1

  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
