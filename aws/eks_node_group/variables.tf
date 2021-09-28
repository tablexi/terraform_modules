variable "cluster" {
  description = "(Required) EKS Cluster to join."
}

variable "node_group_name_prefix" {
  description = "(Required) Creates a unique name beginning with the specified prefix."
  type        = string
}

variable "subnet_ids" {
  description = "(Required) Identifiers of EC2 Subnets to associate with the EKS Node Group."
  type        = list(string)
}

variable "min_size" {
  description = "(Optional) Minimum number of worker nodes."
  default     = 3
}

variable "desired_size" {
  description = "(Optional) Desired number of worker nodes."
  default     = 3
}

variable "max_size" {
  description = "(Optional) Maximum number of worker nodes."
  default     = 6
}

variable "ec2_ssh_key" {
  description = "(Optional) EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group."
  type        = string
}

variable "disk_size" {
  default     = 20
  description = "(Optional) Node disk size in GB"
  type        = number
}

variable "capacity_type" {
  description = "(Optional) Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT. Defaults to ON_DEMAND."
  default     = "ON_DEMAND"
  type        = string
}

variable "instance_types" {
  description = "(Optional) Set of instance types associated with the EKS Node Group. Defaults to [\"t3.medium\"]."
  default     = ["t3.medium"]
  type        = list(string)
}

variable "ami_type" {
  description = "(Optional) Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM."
  default = "AL2_x86_64"
}
