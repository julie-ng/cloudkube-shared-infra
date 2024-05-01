tls_certificates = {
  dev = {
    root = {
      name      = "dev-cloudkube"
      cert_path = "./certs/2024/combined_dev_cloudkube_io.pem"
    }
    wildcard = {
      name      = "wildcard-dev-cloudkube"
      cert_path = "./certs/2024/combined_star_dev_cloudkube_io.pem"
    }
  }

  staging = {
    root = {
      name      = "staging-cloudkube"
      cert_path = "./certs/2024/combined_staging_cloudkube_io.pem"
    }

    wildcard = {
      name      = "wildcard-staging-cloudkube"
      cert_path = "./certs/2024/combined_star_staging_cloudkube_io.pem"
    }
  }

  prod = {
    root = {
      name      = "cloudkube"
      cert_path = "./certs/2024/combined_cloudkube_io.pem"
    }
    wildcard = {
      name      = "wildcard-cloudkube"
      cert_path = "./certs/2024/combined_star_cloudkube_io.pem"
    }
    aks_cheatsheets = {
      name      = "aks-cheatsheets"
      cert_path = "./certs/2024/combined_aks_cheatsheets_dev.pem"
    }
  }
}
