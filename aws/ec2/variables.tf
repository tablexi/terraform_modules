variable "associate_public_ip_address" {
  default = true
}

variable "ami" {
  default = ""
}

variable "count" {
  default = 2
}

variable "ebs_optimized" {
  default = false
  description = "An Amazon EBS–optimized instance uses an optimized configuration stack and provides additional, dedicated capacity for Amazon EBS I/O. It is only available for certain instance types. http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html"
}

variable "env" {
  default = "production"
}

variable "key_name" {}

variable "name_tag_starting_count" {
  default = 1
  description = "If you need to offset the name of the instance.  IE start with app02"
}

variable "root_block_type" {
  default = "gp2"
}

variable "root_block_size" {
  default = "8"
}

variable "subnets" {
  type = "list"
}

variable "type" {
  default = "t2.small"
}

variable "vpc_security_group_ids" {
  type = "list"
  default = []
}

variable "name" {
  description = "The name of the instance. This will be appended with the count number. IE test-app01."
}
