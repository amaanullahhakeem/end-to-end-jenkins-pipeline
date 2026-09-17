variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
}

variable "cluster_version" {
    description = "The version of the EKS cluster"
    type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC where the EKS cluster will be created"
    type        = string
}

variable "private_subnet_ids" {
    description = "A list of private subnet IDs for the EKS cluster"
    type        = list(string)
}

variable "aws_region" {
  description = "This is the region code"
  type        = string
}
