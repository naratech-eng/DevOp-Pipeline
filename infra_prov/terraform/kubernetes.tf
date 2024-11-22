# Create a namespace for our applications
resource "kubernetes_namespace" "apps" {
  metadata {
    name = "${var.environment}-apps"
  }
}

# Create a namespace for monitoring tools
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Install Ingress Controller using Helm
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = "NodePort"  # Using NodePort for home server setup
  }

  set {
    name  = "controller.hostPort.enabled"
    value = "true"
  }
}

# Install cert-manager for SSL certificates
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}
