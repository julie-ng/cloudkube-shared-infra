# =========
#  Outputs
# =========

output "main" {
  value = module.cloudkube.main
}

output "me" {
  value = module.cloudkube.me
}

output "DNS" {
  value = module.cloudkube.DNS
}

output "key_vaults" {
  value = module.cloudkube.key_vaults
}

output "tls_certificates" {
  value = module.cloudkube.tls_certificates
}
