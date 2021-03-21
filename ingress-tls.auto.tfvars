# Inner Source? NO!
# -----------------
# This is *not* a good example for inner source because one
# a cluster has access to these certicates, they can extract it.
#
# This file is here just to make @julie-ng's life easier ;-)

ingress_configs = {
  dev = {
    ingress_public_ip    = "52.182.209.82"
    ingress_user_mi_name = "k8s-apps-dev-hmg-ingress-pod-mi"
    ingress_user_mi_rg   = "k8s-apps-dev-hmg-rg"
    ingress_cert_name    = "wildcard-dev-onazureio"
  }
}
