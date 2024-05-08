resource "aws_organizations_organization" "default" {
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set
}

resource "aws_account_primary_contact" "root" {
  address_line_1     = try(var.primary_contact.address_line_1, null)
  address_line_2     = try(var.primary_contact.address_line_2, null)
  address_line_3     = try(var.primary_contact.address_line_3, null)
  city               = try(var.primary_contact.city, null)
  company_name       = try(var.primary_contact.company_name, null)
  country_code       = try(var.primary_contact.country_code, null)
  district_or_county = try(var.primary_contact.district_or_county, null)
  full_name          = try(var.primary_contact.full_name, null)
  phone_number       = try(var.primary_contact.phone_number, null)
  postal_code        = try(var.primary_contact.postal_code, null)
  state_or_region    = try(var.primary_contact.state_or_region, null)
  website_url        = try(var.primary_contact.website_url, null)
}

resource "aws_account_alternate_contact" "root_operations" {
  alternate_contact_type = "OPERATIONS"

  name          = try(var.operations_contact.name, var.primary_contact.full_name)
  title         = var.operations_contact.title
  email_address = var.operations_contact.email_address
  phone_number  = try(var.operations_contact.phone_number, var.primary_contact.phone_number)
}

resource "aws_account_alternate_contact" "root_billing" {
  alternate_contact_type = "BILLING"

  name          = try(var.billing_contact.name, var.primary_contact.full_name)
  title         = var.billing_contact.title
  email_address = var.billing_contact.email_address
  phone_number  = try(var.billing_contact.phone_number, var.primary_contact.phone_number)
}

resource "aws_account_alternate_contact" "root_security" {
  alternate_contact_type = "SECURITY"

  name          = try(var.security_contact.name, var.primary_contact.full_name)
  title         = var.security_contact.title
  email_address = var.security_contact.email_address
  phone_number  = try(var.security_contact.phone_number, var.primary_contact.phone_number)
}
