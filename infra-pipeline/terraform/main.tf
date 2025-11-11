
terraform {
  required_version = ">= 1.6.0"
}

variable "env" {
  type    = string
  default = "staging"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "cloud_design_module_source" {
  description = "Terraform module source for cloud-design infra (e.g., a registry module or a Git URL)"
  type        = string
  default     = "../cloud-design/infra/terraform"
}

variable "crud_master_repo_url" {
  description = "Git URL or registry path to the crud-master application; used by pipelines, not Terraform"
  type        = string
  default     = "https://example.com/your/crud-master.git"
}

# Example usage: reference the network/app modules provided by your cloud-design repo
module "cloud_design" {
  source = var.cloud_design_module_source

  env    = var.env
  region = var.region
  # Add any required inputs here to match the real module interface
}

output "env" {
  value = var.env
}
