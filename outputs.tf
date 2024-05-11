# output "resource_group" {
#   value = module.cloudkube.resource_group
# }

output "storage_account" {
  value = module.cloudkube.storage_account
}
output "DNS" {
  value = module.cloudkube.DNS
}

output "key_vaults" {
  value = module.key_vaults
}

output "github_identities" {
  value = module.github_identities
}

output "container_registry" {
  value = module.container_registry
}
