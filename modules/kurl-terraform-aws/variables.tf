variable "name" {
  description = "Name for all the resources as identifier"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Tags applied to resources created with this module"
  type        = map(string)
  default     = {}
}

locals {
  // Merge the default tags and user-specified tags.
  // User-specified tags take precedence over the default.
  common_master_tags = merge(
    {
      Name = "${var.name}-kurl-master"
    },
    var.tags,
  )
  common_node_tags = merge(
    {
      Name = "${var.name}-kurl-node"
    },
    var.tags,
  )
}

variable "ssm_policy_arn" {
  description = "SSM Policy to be attached to instance profile"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "master_subnets" {
  description = "ID of the aws subnets to place the master instance"
  type        = list(string)
}

variable "node_subnets" {
  description = "ID of the aws subnets to place the node instance"
  type        = list(string)
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks that the k8s instance accepts connections from this subnets"
  type        = list(string)
}

variable "image_id" {
  description = "AMI of the Vault instance. Default to the latest Amazon Linux 2"
  type        = string
  default     = ""
}

variable "kurl_config" {
  description = "Kurl Config Installer"
  type        = string
  default     = ""
}

variable "desired_node_size" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = 0
}
