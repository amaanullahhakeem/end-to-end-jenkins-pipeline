#Variables for VPC module

variable "name" {
  description = "The name of the VPC"
  type        = string
}


variable "availability_zone_a" {
  description = "The availability zone for the public subnet A"
  type        = string
}

variable "availability_zone_b" {
  description = "The availability zone for the public subnet B"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

