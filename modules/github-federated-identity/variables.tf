variable "base_name" {}
variable "description" {
  type    = string
  default = "Federated identity for use with GitHub hosted agents"
}
variable "github_org" {}
variable "github_repo" {}
variable "github_env" {}

variable "notes" {
  type    = string
  default = "This secretless federated credential is used for Azure deployments demos with GitHub Actions"
}
variable "service_management_reference" {}
