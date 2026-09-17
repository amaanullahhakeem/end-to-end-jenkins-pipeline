terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    #Heml Required Provider
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

#Aws Provider
provider "aws" {
  region = var.aws_region
}

#Helm Provider

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name,
        "--region",
        var.aws_region
      ]
    }
  }
}


#VPC Config source
module "vpc" {
  source = "../../modules/vpc"

  name                = var.name
  vpc_cidr            = var.vpc_cidr
  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b
}

#EKS Conifg source
module "eks" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  aws_region         = var.aws_region
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}


#ECR config source
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "${var.cluster_name}/spring-boot-app"
}


#Helm Release
resource "helm_release" "aws_load_balancer_controller" {
  name      = "aws-load-balancer-controller"
  namespace = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.14.0"

  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 600

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }
  ]

  depends_on = [
    module.eks
  ]
}
