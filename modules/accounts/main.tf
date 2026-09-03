resource "aws_organizations_account" "default" {
  for_each = var.accounts

  name                       = each.key
  email                      = each.value.email
  close_on_deletion          = each.value.close_on_deletion
  iam_user_access_to_billing = each.value.iam_user_access_to_billing
  tags                       = merge(var.tags, each.value.tags)
  parent_id                  = each.value.parent_id
}

locals {
  delegated_administrators = flatten([
    for account_name, account in var.accounts : [
      for service in account.delegated_administrator_services : { service_principal : service, account_name : account_name }
    ]
  ])
}

resource "aws_organizations_delegated_administrator" "default" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : "${delegated_administrator.account_name}-${delegated_administrator.service_principal}" => delegated_administrator
  }

  account_id        = aws_organizations_account.default[each.value.account_name].id
  service_principal = each.value.service_principal

  depends_on = [aws_organizations_account.default]
}

### Securityhub organization settings
resource "aws_securityhub_organization_admin_account" "default" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : delegated_administrator.account_name => delegated_administrator if delegated_administrator.service_principal == "securityhub.amazonaws.com"
  }
  admin_account_id = aws_organizations_account.default[each.value.account_name].id
}

### FMS: the Firewall Manager administrator association (aws_fms_admin_account) only works in us-east-1,
### see ../fms-admin. Listing fms.amazonaws.com in delegated_administrator_services still registers the
### Organizations delegated administrator here.

### GuardDuty organization settings
resource "aws_guardduty_detector" "default" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : delegated_administrator.account_name => delegated_administrator if delegated_administrator.service_principal == "guardduty.amazonaws.com"
  }
}

resource "aws_guardduty_organization_admin_account" "default" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : delegated_administrator.account_name => delegated_administrator if delegated_administrator.service_principal == "guardduty.amazonaws.com"
  }
  admin_account_id = aws_organizations_account.default[each.value.account_name].id
  depends_on       = [aws_guardduty_detector.default]
}

### Inspector organization settings
resource "aws_inspector2_delegated_admin_account" "default" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : delegated_administrator.account_name => delegated_administrator if delegated_administrator.service_principal == "inspector2.amazonaws.com"
  }
  account_id = aws_organizations_account.default[each.value.account_name].id
}

### IPAM organization settings
resource "aws_vpc_ipam_organization_admin_account" "default" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : delegated_administrator.account_name => delegated_administrator if delegated_administrator.service_principal == "ipam.amazonaws.com"
  }
  delegated_admin_account_id = aws_organizations_account.default[each.value.account_name].id
}

### Account Management
resource "aws_account_primary_contact" "default" {
  for_each = var.contacts != null ? var.accounts : {}

  account_id         = aws_organizations_account.default[each.key].id
  address_line_1     = var.contacts.primary_contact.address_line_1
  address_line_2     = var.contacts.primary_contact.address_line_2
  address_line_3     = var.contacts.primary_contact.address_line_3
  city               = var.contacts.primary_contact.city
  company_name       = var.contacts.primary_contact.company_name
  country_code       = var.contacts.primary_contact.country_code
  district_or_county = var.contacts.primary_contact.district_or_county
  full_name          = var.contacts.primary_contact.full_name
  phone_number       = var.contacts.primary_contact.phone_number
  postal_code        = var.contacts.primary_contact.postal_code
  state_or_region    = var.contacts.primary_contact.state_or_region
  website_url        = var.contacts.primary_contact.website_url
}

resource "aws_account_alternate_contact" "operations" {
  for_each = try(var.contacts.operations_contact, null) != null ? var.accounts : {}

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "OPERATIONS"

  name          = var.contacts.operations_contact.name
  title         = var.contacts.operations_contact.title
  email_address = var.contacts.operations_contact.email_address
  phone_number  = coalesce(var.contacts.operations_contact.phone_number, var.contacts.primary_contact.phone_number)
}

resource "aws_account_alternate_contact" "billing" {
  for_each = try(var.contacts.billing_contact, null) != null ? var.accounts : {}

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "BILLING"

  name          = var.contacts.billing_contact.name
  title         = var.contacts.billing_contact.title
  email_address = var.contacts.billing_contact.email_address
  phone_number  = coalesce(var.contacts.billing_contact.phone_number, var.contacts.primary_contact.phone_number)
}

resource "aws_account_alternate_contact" "security" {
  for_each = try(var.contacts.security_contact, null) != null ? var.accounts : {}

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "SECURITY"

  name          = var.contacts.security_contact.name
  title         = var.contacts.security_contact.title
  email_address = var.contacts.security_contact.email_address
  phone_number  = coalesce(var.contacts.security_contact.phone_number, var.contacts.primary_contact.phone_number)
}
