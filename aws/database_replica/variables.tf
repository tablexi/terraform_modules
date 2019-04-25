variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  default     = true
}

variable "backup_retention_period" {
  description = "Backup retention period for AWS RDS instance in days."
  default     = 0
}

variable "env" {
  description = "Environment the RDS instance is associated with."
  default     = "production"
}

variable "engine_version" {
  description = "Engine version. Defaults to the version of the source database."
  default     = ""
}

variable "identifier" {
  description = "Set the identifier for the instance"
  default     = ""
}

variable "iops" {
  description = "(Optional) The amount of provisioned IOPS. Setting this implies a storage_type of io1."
  default     = 0
}

variable "multi_az" {
  description = "AWS RDS automatically creates a primary DB Instance and synchronously replicates the data to a standby instance in a different Availability Zone."
  default     = false
}

variable "name" {
  description = "Name of the RDS instance and various RDS services (EG subnet group and security groups)."
}

variable "node_type" {
  description = "AWS RDS instance type."
  default     = "db.t2.medium"
}

variable "parameter_group_name" {
  description = "Name of a parameter group to use with the RDS instance instead of the default."
  default     = ""
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible."
  default     = true
}

variable "security_groups_for_ingress" {
  description = "Security groups which should be allowed ingress on the RDS instance."
  default     = []
}

variable "cidr_blocks_for_ingress" {
  description = "CIDR blocks which should be allowed ingress on the RDS instance."
  default     = []
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot before destroying instance."
  default     = true
}

variable "source_db" {
  description = "Source database identifier."
}

variable "storage_type" {
  description = "(Optional) One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is the storage type of the source database, so only set this if you want to use a different storage type on the replica."
  default     = ""
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = "map"
}

variable "vpc_id" {
  description = "VPC id to associate this RDS instance with."
}

variable "vpc_security_group_ids" {
  description = "Additional security group ids to associate this RDS instance with."
  type        = "list"
  default     = []
}
