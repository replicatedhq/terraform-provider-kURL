variable "cluster_name" {
  description = "Kurl Cluster Name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "image_id" {
  description = "AWS EC2 AMI Image ID"
  type        = string
  default     = ""
}

variable "env" {
  description = "Infrastructure environment"
  type        = string
}

variable "account_owner" {
  description = "Account owner"
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block"
  type        = string
}

variable "public_cidr_block_map" {
  description = "A map where the key is AZ short name and value is private subnet CIDR"
  type        = map(string)
}

variable "kurl_config_path" {
  description = "File path of kurl config yaml"
  type        = string
}
variable "desired_node_size" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = 0
}
