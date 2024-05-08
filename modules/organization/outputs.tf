output "contacts" {
  description = "The contacts for the organization"
  value = {
    primary_contact    = aws_account_primary_contact.root,
    operations_contact = aws_account_alternate_contact.root_operations,
    billing_contact    = aws_account_alternate_contact.root_billing,
    security_contact   = aws_account_alternate_contact.root_security
  }
}

output "organization_root_id" {
  description = "The ID of the organization root"
  value       = aws_organizations_organization.default.roots[0].id
}
