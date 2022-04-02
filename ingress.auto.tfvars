# ==============
#  Ingress RBAC
# ==============
# - configures rbac to access TLS certificates
# - NOT good example for inner source

ingress_configs = {
  dev = {
    ingress_user_mi_name = "cloudkube-dev-nyl9-cluster-agentpool"
    ingress_user_mi_rg   = "cloudkube-dev-nyl9-managed-rg"
  }
  staging = {
    ingress_user_mi_name = "cloudkube-staging-ingress-pod-mi"
    ingress_user_mi_rg   = "cloudkube-staging-d7c-rg"
  }
}
