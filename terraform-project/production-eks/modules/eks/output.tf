output "cluster_role_arn" {
  description = "The ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster.arn
}

output "cluster_role_name" {
  description = "The name of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster.name
}

output "vpc_id" {
  description = "The ID of the VPC where the EKS cluster is created"
  value       = var.vpc_id
}

output "private_subnet_ids" {
  description = "A list of private subnet IDs where the EKS cluster is created"
  value       = var.private_subnet_ids
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}
