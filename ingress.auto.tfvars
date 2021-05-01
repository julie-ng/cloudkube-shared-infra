# ==============
#  Ingress RBAC
# ==============
# - configures rbac to access TLS certificates
# - not good example for inner source

ingress_configs = {
  dev = {
    ingress_user_mi_name = "cloudkube-dev-ingress-pod-mi"
    ingress_user_mi_rg   = "cloudkube-dev-r9er-managed-rg"
  }
}
