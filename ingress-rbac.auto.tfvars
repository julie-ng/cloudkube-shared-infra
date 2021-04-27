# Inner Source? NO!
# -----------------
# This is *not* a good example for inner source because one
# a cluster has access to these certicates, they can extract it.
#
# This file is here just to make @julie-ng's life easier ;-)

ingress_configs = {
  cloudkube_dev = {
    ingress_user_mi_name = "cloudkube-dev-ingress-pod-mi"
    ingress_user_mi_rg   = "cloudkube-dev-r9er-managed-rg"
    ingress_cert_name    = "wildcard-dev-cloudkube"
  }
}
