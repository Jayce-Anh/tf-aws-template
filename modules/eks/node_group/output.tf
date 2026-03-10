############################ OUTPUT ############################
# EKS cluster id
output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

# EKS cluster name
output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

# EKS cluster endpoint
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

# EKS cluster ARN
output "eks_cluster_arn" {
  value = aws_eks_cluster.eks.arn
}

# EKS cluster version
output "eks_cluster_version" {
  value = aws_eks_cluster.eks.version
}

# EKS add-ons
output "eks_add_ons" {
  value = aws_eks_addon.eks_addons_extra
}

# EKS cluster CA certificate
output "eks_cluster_ca" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

# OIDC provider
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.eks.url
}

# ALB Controller
output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller.arn
}