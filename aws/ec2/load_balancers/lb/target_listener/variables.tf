variable "certificate_arn" {
  description = "The ARN of an SSL server certificate"
  default = ""
}

variable "sg_for_access_by_sgs_id" {
  description = "The outbound security group to apply the ingress port changes to."
  default = ""
}

variable "sg_on_lb_cidr_blocks" {
  description = "List of cidr_blocks to give access to the LB"
  default = ["0.0.0.0/0"]
}

variable "sg_on_lb_id" {
  description = "The security group to apply the ingress port changes to."
  default = ""
}

variable "sg_on_lb_source_ids" {
  description = "List of security groups to give access to the LB"
  default = []
}

variable "deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused"
  default = 30
}
variable "health_check" {
  description = "Map of target health check parameters"
  default = {}
}

variable "listener_arn" {
  description = "If creating a LB listener rule, provide the ARN of the LB listener"
  default = ""
}

variable "listener_rule" {
  description = "Map of listener rule parameters"
  default = {}
}

variable "lb_arn" {
  description = "The ARN of the load balancer"
  default = ""
}

variable "name" {
  description = "The name of the LB target group"
}

variable "port" {
  description = "The port on which targets receive traffic"
}

variable "protocol" {
  description = "The protocol to use for routing traffic to the targets"
}

variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener"
  default = "ELBSecurityPolicy-2016-08"
}

variable "target_ids" {
  description = "List of ids (ECS/EC2 ID's or IP's) to target"
  type = "list"
}

variable "target_id_count" {
  description = "Count of ids being added to target"
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the target group"
}
