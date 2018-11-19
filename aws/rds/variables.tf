variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  default     = true
}

variable "backup_retention_period" {
  description = "Backup retention period for AWS RDS instance in days."
  default     = 7
}

variable "create_db_subnet_group" {
  description = "Create a db subnet group specific to this database"
  default     = true
}

variable "env" {
  description = "Environment the RDS instance is associated with."
  default     = "production"
}

variable "engine" {
  description = "Postgres, MySQL, etc."

  # default = "postgres"
}

variable "engine_version" {
  description = "Version # of the Postgres or MySQL installation. Do not include patch version as it is auto upgraded."

  # default = "9.6"
}

variable "identifier" {
  description = "Set the identifier for the instance"
  default     = ""
}

variable "kms_key_id" {
  description = "If you are using volume encryption, you can use this variable to set the specific key arn."
  default     = ""
}

variable "multi_az" {
  description = "AWS RDS automatically creates a primary DB Instance and synchronously replicates the data to a standby instance in a different Availability Zone."
  default     = true
}

variable "name" {
  description = "Name of the RDS instance and various RDS services (EG subnet group and security groups)."
}

variable "node_type" {
  description = "AWS RDS instance type."
  default     = "db.t2.medium"
}

variable "parameter_group_name" {
  description = "Name of a parameter group to use with the RDS instance."
  default     = ""
}

variable "parameter_group_provided" {
  description = "If the parameter_group_name is provided, must be set to true."
  default     = false
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible."
  default     = true
}

variable "security_groups_for_ingress" {
  description = "Security groups which should be allowed ingress on the RDS instance."
  default     = []
}

variable "sg_cidr_blocks" {
  description = "cidr_blocks to give RDS port access to."
  default     = []
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot before destroying instance."
  default     = false
}

variable "source_db" {
  description = "recplication source db"
  default     = ""
}

variable "storage" {
  description = "Volume storage size for the RDS instance in gigabytes."
  default     = 5
}

variable "storage_encrypted" {
  description = "Encryption at rest"
  default     = false
}

variable "storage_type" {
  description = "Volume type to use.  Options: Standard(magnetic), gp2(SSD), or io1(provisioned IOPS SSD)"
  default     = "gp2"
}

variable "subnets" {
  description = "A list of subnets that the RDS instance can be added to."
  type        = "list"
}

variable "subnet_group_name" {
  description = "Set db subnet group name"
  default     = ""
}

variable "username" {
  description = "RDS instance username"
  default     = ""
}

variable "username_suffix" {
  description = "Allows for greater customization of the RDS instance superuser.  The username arguments starts with the name variable and then this variable is appended to it."
  default     = "admin"
}

variable "vpc_id" {
  description = "VPC id to associate this RDS instance with."
}

variable "vpc_security_group_ids" {
  description = "Additional security group ids to associate this RDS instance with."
  type        = "list"
  default     = []
}
