variable "allow_major_version_upgrade" {
  description = "Allow for major version upgrade from terraform"
  default = true
}

variable "backup_retention_period" {
  description = "Backup retention period for AWS RDS instance in days."
  default = 7
}

variable "create_db_subnet_group" {
  description = "Create a db subnet group specific to this database"
  default = true
}

variable "env" {
  description = "Environment the RDS instance is associated with."
  default = "production"
}

variable "identifier" {
  description = "Set the identifier for the instance"
  default = ""
}

variable "identifier_suffix" {
  description = "The RDS instance identifier is the unique name of the instance.  To make this change backwards compatibile, it can be left blank."
  default = "-postgres"
}

variable "multi_az" {
  description = "AWS RDS automatically creates a primary DB Instance and synchronously replicates the data to a standby instance in a different Availability Zone."
  default = true
}

variable "name" {
  description = "Name of the RDS instance and various RDS services (EG subnet group and security groups)."
}

variable "node_type" {
  description = "AWS RDS instance type."
  default = "db.t2.medium"
}

variable "parameter_group_name" {
  description = "Name of a parameter group to use with the RDS instance."
  default = ""
}

variable "port" {
  description = "Override the default port"
  default = ""
}

variable "sg_cidr_blocks" {
  description = "cidr_blocks to give RDS port access to."
  default = []
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot before destroying instance."
  default = false
}

variable "source_db" {
  description = "recplication source db"
  default = ""
}

variable "storage" {
  description = "Volume storage size for the RDS instance in gigabytes."
  default = 5
}

variable "storage_type" {
  description = "Volume type to use.  Options: Standard(magnetic), gp2(SSD), or io1(provisioned IOPS SSD)"
  default = "gp2"
}

variable "subnets" {
  description = "A list of subnets that the RDS instance can be added to."
  type = "list"
}

variable "subnet_group_name" {
  description = "Set db subnet group name"
  default = ""
}
variable "username" {
  description = "RDS instance username"
  default = ""
}

variable "username_suffix" {
  description = "Allows for greater customization of the RDS instance superuser.  The username arguments starts with the name variable and then this variable is appended to it."
  default = "admin"
}

variable "version" {
  description = "Version # of the Postgres or MySQL installation. Do not include patch version as it it is auto upgraded."
  # default = "9.6"
}

variable "vpc_id" {
  description = "VPC id to associate this RDS instance with."
}

variable "engine" {
  description = "Postgres, MySQL, etc."
  # default = "postgres"
}