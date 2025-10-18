module "eks_auth" {
  source  = "github.com/terraform-aws-modules/terraform-aws-eks//modules/aws-auth?ref=v20.35.0"


  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::311141539357:user/AWS_CLI_User"
      username = "admin"
      groups   = ["system:masters"]
    }
  ]
}
