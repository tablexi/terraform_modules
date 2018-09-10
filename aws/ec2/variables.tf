variable "associate_public_ip_address" {
  default = true
}

variable "ami" {
  description = "(Required) The AMI to use for the instance."
}

variable "count" {
  default = 2
}

variable "ebs_optimized" {
  default     = false
  description = "An Amazon EBS–optimized instance uses an optimized configuration stack and provides additional, dedicated capacity for Amazon EBS I/O. It is only available for certain instance types. http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html"
}

variable "enable_eip" {
  default     = false
  description = "Enable EIP for instances"
}

variable "env" {
  default = "production"
}

variable "key_name" {}

variable "name_tag_starting_count" {
  default     = 1
  description = "If you need to offset the name of the instance.  IE start with app02"
}

variable "root_block_type" {
  default = "gp2"
}

variable "root_block_size" {
  default = 16
}

variable "subnets" {
  type = "list"
}

variable "type" {
  default = "t2.small"
}

variable "vpc_security_group_ids" {
  type    = "list"
  default = []
}

variable "vpc_id" {
  description = "VPC to create resources in"
}

variable "name" {
  description = "The name of the instance. This will be appended with the count number. IE test-app01."
}

variable "iam_instance_profile" {
  default     = ""
  description = "The IAM instance profile to associate with the instance."
}
