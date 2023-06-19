output "accounts" {
  value       = module.organization.accounts
  description = "All AWS accounts."
}

output "organizational_units" {
  value       = module.organization.organizational_units
  description = "All AWS Organizational Units."
}

output "organization" {
  value       = module.organization.organization
  description = "The AWS Organization"
}

output "organizations_policies" {
  value       = module.organization.organizations_policies
  description = "The created Organization policies."
}

output "organizations_delegated_administrator" {
  value       = module.organization.organizations_delegated_administrator
  description = "The AWS Organization delegated administrator assignments."
}
