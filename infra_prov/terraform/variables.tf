variable "kubernetes_config_path" {
  description = "Path to the kubeadm generated Kubernetes configuration file"
  type        = string
  default     = "/etc/kubernetes/admin.conf"  # Default kubeadm config path
}

variable "kubernetes_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = "kubernetes-admin@kubernetes"  # Default kubeadm context
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "domain" {
  description = "Domain name for the applications"
  type        = string
  default     = "dev.naratecho.com"
}

# Kubernetes cluster configuration
variable "pod_network_cidr" {
  description = "CIDR for pod network"
  type        = string
  default     = "10.244.0.0/16"  # Default for Flannel
}

variable "service_cidr" {
  description = "CIDR for service network"
  type        = string
  default     = "10.96.0.0/12"  # Default for kubeadm
}

variable "storage_class" {
  description = "Default storage class for persistent volumes"
  type        = string
  default     = "local-path"  # This is the default for k3s
}
