variable "name" {
  description = "Name of the environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zone_a" {
  description = "First Availability Zone"
  type        = string
}

variable "availability_zone_b" {
  description = "Second Availability Zone"
  type        = string
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of the EKS cluster"
  type        = string
}

