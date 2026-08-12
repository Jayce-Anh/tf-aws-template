####################### ARGOCD HELM RELEASE #######################

resource "htpasswd_password" "argocd" {
  password = jsondecode(aws_secretsmanager_secret_version.addons.secret_string).argocd_password
}

resource "time_static" "argocd_admin_password_mtime" {
  triggers = {
    hash = htpasswd_password.argocd.bcrypt
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  timeout          = 120
  wait             = true

  set = [
    {
      name  = "server.service.type"
      value = "ClusterIP"
    },
    {
      name  = "configs.params.server\\.insecure"
      value = "true"
    },
    {
      name  = "server.ingress.enabled"
      value = "false"
    },
    {
      name  = "configs.cm.url"
      value = "https://argocd.${var.project.name}.jayce-lab.works"
    },
    {
      name  = "configs.secret.argocdServerAdminPasswordMtime"
      value = time_static.argocd_admin_password_mtime.rfc3339
    },
  ]

  set_sensitive = [
    {
      name  = "configs.secret.argocdServerAdminPassword"
      value = htpasswd_password.argocd.bcrypt
    },
  ]

  depends_on = [
    helm_release.load_balancer_controller,
    helm_release.cert_manager,
    kubectl_manifest.cert_manager_cluster_issuer,
    aws_iam_role.argocd,
    aws_eks_pod_identity_association.argocd,
    aws_secretsmanager_secret_version.addons,
  ]
}

resource "kubernetes_secret_v1" "argocd_repo" {
  metadata {
    name      = "argocd-repo-creds"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type     = "git"
    url      = "https://gitlab.com/shopping-cart796042412/devops/shoppingcart-manifest.git"
    username = "oauth2"
    password = aws_secretsmanager_secret_version.helm-git-token.secret_string
  }

  depends_on = [helm_release.argocd]
}

#============ ArgoCD Target Group Binding =============#
# server.insecure=true → service port 80 (matches old insecure mode)
resource "kubectl_manifest" "argocd_tgb" {
  provider = kubectl

  yaml_body = yamlencode({
    apiVersion = "elbv2.k8s.aws/v1beta1"
    kind       = "TargetGroupBinding"
    metadata = {
      name      = "argocd-tgb"
      namespace = "argocd"
    }
    spec = {
      serviceRef = {
        name = "argocd-server"
        port = 80
      }
      targetGroupARN = "${var.helm_argocd_tg_arn}"
      targetType     = "ip"
    }
  })

  depends_on = [
    helm_release.argocd,
    helm_release.load_balancer_controller,
  ]
}

resource "kubectl_manifest" "argocd_root_application" {
  provider = kubectl

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argocd
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: '${var.helm_repo_url}'
    targetRevision: '${var.helm_target_revision}'
    path: 'argocd/'
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML

  depends_on = [
    helm_release.argocd,
    kubernetes_secret_v1.argocd_repo,
  ]
}
