output "accounts" {
  value       = aws_organizations_account.default
  description = "All AWS accounts."
}

output "organizational_units" {
  value       = local.ous
  description = "All AWS Organizational Units."
}

output "organization" {
  value       = aws_organizations_organization.default
  description = "The AWS Organization"
}

output "organizations_policies" {
  value       = aws_organizations_policy.default
  description = "The created Organization policies."
}

output "organizations_delegated_administrator" {
  value       = aws_organizations_delegated_administrator.default
  description = "The AWS Organization delegated administrator assignments."
}
