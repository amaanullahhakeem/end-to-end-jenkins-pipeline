output "name" {
  description = "The name of the EKS cluster"
  value       = var.name
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = var.cluster_name
}

output "cluster_version" {
  description = "The version of the EKS cluster"
  value       = var.cluster_version
}

output "vpc_id" {
  description = "This is the ID of the VPC where the EKS cluster is created"
  value       = module.eks.vpc_id
}


