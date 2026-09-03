output "organization_id" {
  value       = module.organization.organization_id
  description = "The ID of the AWS Organization."
}

output "organization_root_id" {
  value       = module.organization.organization_root_id
  description = "The ID of the AWS Organization root."
}

output "organizational_units" {
  value       = module.organization_units.ous
  description = "The created AWS Organizational Units."
}

output "accounts" {
  value       = module.accounts.accounts
  description = "The created AWS accounts."
}

output "delegated_administrators" {
  value       = module.accounts.delegated_administrators
  description = "The AWS Organization delegated administrator registrations."
}

output "organizations_policies" {
  value       = module.org_policies.policies
  description = "The created AWS Organization policies."
}
