provider "aws" {
  region              = local.project.region
  allowed_account_ids = local.project.account_ids
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}

provider "kubernetes" {
  host                   = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_ca)
  token                  = data.aws_eks_cluster_auth.eks.token
}

