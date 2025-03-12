resource "aws_organizations_account" "default" {
  for_each = var.accounts

  name                       = each.key
  email                      = each.value.email
  close_on_deletion          = try(each.value.close_on_deletion, null)
  iam_user_access_to_billing = each.value.iam_user_access_to_billing == null ? "ALLOW" : each.value.iam_user_access_to_billing
  tags                       = merge(each.value.tags, var.tags)
  parent_id                  = try(each.value.parent_id, null)
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

### FMS organization settings
resource "aws_fms_admin_account" "default" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : delegated_administrator.account_name => delegated_administrator if delegated_administrator.service_principal == "fms.amazonaws.com"
  }
  account_id = aws_organizations_account.default[each.value.account_name].id
}

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
  depends_on       = [aws_guardduty_detector.default[0]]
}

### Inspector organization settings
resource "aws_inspector2_delegated_admin_account" "default" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : delegated_administrator.account_name => delegated_administrator if delegated_administrator.service_principal == "inspector2.amazonaws.com"
  }
  account_id = aws_organizations_account.default[each.value.account_name].id
}

### IPAM organization settings
resource "aws_vpc_ipam_organization_admin_account" "example" {
  for_each = {
    for delegated_administrator in local.delegated_administrators : delegated_administrator.account_name => delegated_administrator if delegated_administrator.service_principal == "ipam.amazonaws.com"
  }
  delegated_admin_account_id = aws_organizations_account.default[each.value.account_name].id
}

### Account Management
resource "aws_account_primary_contact" "default" {
  for_each = var.accounts

  account_id         = aws_organizations_account.default[each.key].id
  address_line_1     = var.contacts.primary_contact.address_line_1
  address_line_2     = try(var.contacts.primary_contact.address_line_2, null)
  address_line_3     = try(var.contacts.primary_contact.address_line_3, null)
  city               = var.contacts.primary_contact.city
  company_name       = try(var.contacts.primary_contact.company_name, null)
  country_code       = var.contacts.primary_contact.country_code
  district_or_county = try(var.contacts.primary_contact.district_or_county, null)
  full_name          = var.contacts.primary_contact.full_name
  phone_number       = var.contacts.primary_contact.phone_number
  postal_code        = var.contacts.primary_contact.postal_code
  state_or_region    = try(var.contacts.primary_contact.state_or_region, null)
  website_url        = try(var.contacts.primary_contact.website_url, null)

  depends_on = [aws_organizations_account.default]
}

resource "aws_account_alternate_contact" "operations" {
  for_each = var.accounts

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "OPERATIONS"

  name          = try(var.contacts.operations_contact.name, var.contacts.primary_contact.full_name)
  title         = var.contacts.operations_contact.title
  email_address = var.contacts.operations_contact.email_address
  phone_number  = try(var.contacts.operations_contact.phone_number, var.contacts.primary_contact.phone_number)

  depends_on = [aws_organizations_account.default]
}

resource "aws_account_alternate_contact" "billing" {
  for_each = var.accounts

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "BILLING"

  name          = try(var.contacts.billing_contact.name, var.contacts.primary_contact.full_name)
  title         = var.contacts.billing_contact.title
  email_address = var.contacts.billing_contact.email_address
  phone_number  = try(var.contacts.billing_contact.phone_number, var.contacts.primary_contact.phone_number)

  depends_on = [aws_organizations_account.default]
}

resource "aws_account_alternate_contact" "security" {
  for_each = var.accounts

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "SECURITY"

  name          = try(var.contacts.security_contact.name, var.contacts.primary_contact.full_name)
  title         = var.contacts.security_contact.title
  email_address = var.contacts.security_contact.email_address
  phone_number  = try(var.contacts.security_contact.phone_number, var.contacts.primary_contact.phone_number)

  depends_on = [aws_organizations_account.default]
}
