#EKS Cluster (The actual EKS cluster resource)
resource "aws_eks_cluster" "main" {
  name    = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
  version = var.cluster_version

  tags = {
    Name = var.cluster_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}

#EKS Node Group Configuration
resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  tags = {
    Name = "${var.cluster_name}-node-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEC2ContainerRegistryReadOnly
  ]
}


#IAM Policies & Roles

#EKS Cluster IAM Role (IAM role that allows EKS to manage AWS resources on your behalf)
resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "${var.cluster_name}-eks-cluster-role"
  }
  
}


#AmazonEKSServicePolicy (Permission to allow EKS to manage AWS resources on your behalf)
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

#Node Group IAM Role (IAM role that allows EKS to manage AWS resources on your behalf for the node group)
resource "aws_iam_role" "eks_node_group" {
  name = "${var.cluster_name}-eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "${var.cluster_name}-eks-node-group-role"
  }
}

#Node Group IAM Role Policy Attachments (Permissions to allow EKS to manage AWS resources on your behalf for the node group)
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
} 

#Node Group IAM Role Policy Attachments (Permissions to allow EKS to manage AWS resources on your behalf for the node group)
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}
#Node Group IAM Role Policy Attachments (Permission to AWS ECR service to Pull/Push)
resource "aws_iam_role_policy_attachment" "eks_node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

#Existing Data of Awd Load Balancer Controller
data "aws_iam_policy" "aws_load_balancer_controller" {
  arn = "arn:aws:iam::743887468885:policy/AWSLoadBalancerControllerIAMPolicy"
}


#IAM Role
resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "AmazonEKSLoadBalancerControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "pods.eks.amazonaws.com"
      }

      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }]
  })
}

#Attach the existing policy
resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = data.aws_iam_policy.aws_load_balancer_controller.arn
}

#Add Pod Identity Association.
resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.aws_load_balancer_controller.arn
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = var.cluster_name

  addon_name = "eks-pod-identity-agent"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name = "${var.cluster_name}-pod-identity-agent"
  }

  depends_on = [
    aws_iam_role.eks_cluster
  ]
}

