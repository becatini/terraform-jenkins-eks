# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    #"Name"        = "eks-vpc"
    #"Terraform"   = "true"
    #"Environment" = "dev"
    "kubernetes.io/cluster/eks-test" = "shared"
  }

  public_subnet_tags = {
    #"Name" = "eks-subnet"
    "kubernetes.io/cluster/eks-test" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    #"Name" = "eks-subnet"
    "kubernetes.io/cluster/eks-test" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# search for "terraform eks module"
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.14.0
module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "eks-test"
  cluster_version = "1.24"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  eks_managed_node_groups = {
    node = {
      min_size = 1
      max_size = 3
      desired_size = 2

      instance_type = ["t2.small"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}