output "resource_group" {
  value = module.cloudkube.resource_group
}

output "storage_account" {
  value = module.cloudkube.storage_account
}

output "container_registry" {
  value = module.cloudkube.container_registry
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
