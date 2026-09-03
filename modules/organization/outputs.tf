output "contacts" {
  description = "The contacts for the organization management account"
  value = {
    primary_contact    = one(aws_account_primary_contact.root)
    operations_contact = one(aws_account_alternate_contact.root_operations)
    billing_contact    = one(aws_account_alternate_contact.root_billing)
    security_contact   = one(aws_account_alternate_contact.root_security)
  }
}

output "organization_root_id" {
  description = "The ID of the organization root"
  value       = aws_organizations_organization.default.roots[0].id
}

output "organization_id" {
  description = "The ID of the organization"
  value       = aws_organizations_organization.default.id
}

output "organization" {
  description = "The full AWS Organization resource"
  value       = aws_organizations_organization.default
}
