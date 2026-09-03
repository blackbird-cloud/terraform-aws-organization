resource "aws_organizations_organization" "default" {
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set
}

resource "aws_account_primary_contact" "root" {
  count = var.primary_contact != null ? 1 : 0

  address_line_1     = var.primary_contact.address_line_1
  address_line_2     = var.primary_contact.address_line_2
  address_line_3     = var.primary_contact.address_line_3
  city               = var.primary_contact.city
  company_name       = var.primary_contact.company_name
  country_code       = var.primary_contact.country_code
  district_or_county = var.primary_contact.district_or_county
  full_name          = var.primary_contact.full_name
  phone_number       = var.primary_contact.phone_number
  postal_code        = var.primary_contact.postal_code
  state_or_region    = var.primary_contact.state_or_region
  website_url        = var.primary_contact.website_url
}

resource "aws_account_alternate_contact" "root_operations" {
  count = var.operations_contact != null ? 1 : 0

  alternate_contact_type = "OPERATIONS"

  name          = var.operations_contact.name
  title         = var.operations_contact.title
  email_address = var.operations_contact.email_address
  phone_number  = try(coalesce(var.operations_contact.phone_number, var.primary_contact.phone_number), null)
}

resource "aws_account_alternate_contact" "root_billing" {
  count = var.billing_contact != null ? 1 : 0

  alternate_contact_type = "BILLING"

  name          = var.billing_contact.name
  title         = var.billing_contact.title
  email_address = var.billing_contact.email_address
  phone_number  = try(coalesce(var.billing_contact.phone_number, var.primary_contact.phone_number), null)
}

resource "aws_account_alternate_contact" "root_security" {
  count = var.security_contact != null ? 1 : 0

  alternate_contact_type = "SECURITY"

  name          = var.security_contact.name
  title         = var.security_contact.title
  email_address = var.security_contact.email_address
  phone_number  = try(coalesce(var.security_contact.phone_number, var.primary_contact.phone_number), null)
}

### RAM organization settings
resource "aws_ram_sharing_with_organization" "default" {
  count = var.aws_ram_sharing_with_organization ? 1 : 0
}
