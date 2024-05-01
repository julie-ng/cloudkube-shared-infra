# =====
#  Dev
# =====

dev_certificates = [
  {
    name     = "dev-cloudkube"
    pem_file = "./certs/2024/combined_dev_cloudkube_io.pem"
  },
  {
    name     = "wildcard-dev-cloudkube"
    pem_file = "./certs/2024/combined_star_dev_cloudkube_io.pem"
  },
  {
    name     = "aks-cheatsheets"
    pem_file = "./certs/2024/combined_dev_aks_cheatsheets_dev.pem"
  }
]

# =========
#  Staging
# ==========

staging_certificates = [
  {
    name     = "staging-cloudkube"
    pem_file = "./certs/2024/combined_staging_cloudkube_io.pem"
  },
  {
    name     = "wildcard-staging-cloudkube"
    pem_file = "./certs/2024/combined_star_staging_cloudkube_io.pem"
  }
]

# ============
#  Production
# ============

prod_certificates = [
  {
    name     = "cloudkube"
    pem_file = "./certs/2024/combined_cloudkube_io.pem"
  },
  {
    name     = "wildcard-cloudkube"
    pem_file = "./certs/2024/combined_star_cloudkube_io.pem"
  },
  {
    name     = "aks-cheatsheets"
    pem_file = "./certs/2024/combined_aks_cheatsheets_dev.pem"
  }
]
