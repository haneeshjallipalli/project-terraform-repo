module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_public_access = true

  # 🛠️ Use this instead of cluster_iam_role_arn
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # Provide custom IAM role for EKS control plane
  create_iam_role = false
  iam_role_arn    = aws_iam_role.eks_cluster_role.arn

  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t3.medium"]

      # Use existing node IAM role
      iam_role_arn = aws_iam_role.eks_node_role.arn
      subnet_ids   = module.vpc.public_subnets
    }
  }
}
