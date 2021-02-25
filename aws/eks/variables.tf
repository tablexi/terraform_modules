variable "capacity_min" {
  description = "Minimum number of nodes to create"
  default     = 3
}

variable "capacity_desired" {
  description = "Desired number of nodes to create"
  default     = 3
}

variable "capacity_max" {
  description = "Maximum number of nodes to create"
  default     = 6
}

variable "uses_nat_gateway" {
  description = "Create a NAT Gateway for all outgoing internet traffic"
  default     = false
  type        = bool
}

variable "ec2_ssh_key" {
  description = "(Optional) EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group."
  type        = string
}

variable "instance_type" {
  default = "t3.medium"
}

variable "name" {
  description = "Name of the cluster"
}

variable "subnet_module" {
  type = object({
    exclude_names = list(string)
    netnum_offset = number
  })
  default = {
    exclude_names = []
    netnum_offset = 0
  }
  description = "(Optional) Expose some subnet module variables to root module"
}

variable "vpc_cidr" {
  description = "(Optional) The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources"
  type        = map(string)
}
