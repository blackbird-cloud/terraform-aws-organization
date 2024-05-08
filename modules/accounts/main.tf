resource "aws_organizations_account" "default" {
  for_each = var.accounts

  name                       = each.key
  email                      = each.value.email
  close_on_deletion          = try(each.value.close_on_deletion, null)
  iam_user_access_to_billing = try(each.value.iam_user_access_to_billing, null)
  tags                       = merge(each.value.tags, try(each.value.tags, {}))
  parent_id                  = try(each.value.parent_id, null)
}

locals {
  delegated_administrators = flatten([
    for account in var.accounts : [
      for service in account.delegated_administrator_services : { service_principal : service, account_name : account.name }
    ]
  ])
}

resource "aws_organizations_delegated_administrator" "default" {
  for_each = {
    for account in local.delegated_administrators : account.service_principal => account
  }

  account_id        = aws_organizations_account.default[each.value.account_name].id
  service_principal = each.value.service_principal

  depends_on = [aws_organizations_account.default]
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
