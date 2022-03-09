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

variable "uses_cluster_autoscaler" {
  description = "Update node group tags and create IAM role with autoscale group credentials"
  default     = false
  type        = bool
}

variable "cluster_autoscaler" {
  description = "Cluster autoscaler namespace name"
  default = {
    namespace      = "kube-system"
    serviceaccount = "cluster-autoscaler"
  }
  type = map(string)
}

variable "ec2_ssh_key" {
  description = "(Optional) EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group."
  type        = string
}

variable "disk_size" {
  default     = 20
  description = "Node disk size in GB"
  type        = number
}

variable "capacity_type" {
  description = "Node group capacity type"
  default     = "ON_DEMAND"
  type        = string
}

variable "instance_types" {
  description = "List of instance types to associate with the node group"
  default     = ["t3.medium"]
  type        = list(string)
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

variable "create_nodes" {
  description = "(Optional) Create a node group for the EKS cluster. Defaults to true."
  default     = true
}

variable "addons" {
  description = "(Optional) List of EKS addons to manage"
  default     = []
  type        = list
}

variable "addon_resolve_conflict" {
  description = "EKS addon conflict resolution NONE|OVERWRITE"
  default     = "OVERWRITE"
  type        = string
}
