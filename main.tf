resource "aws_organizations_organization" "default" {
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set
}

resource "aws_organizations_organizational_unit" "level_one" {
  for_each = {
    for ou in var.organizational_units : ou.name => ou
  }
  name      = each.value.name
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = merge(var.tags, each.value.tags)
}

locals {
  level_one_accounts = flatten([
    for level_one_ou in var.organizational_units : [for account in try(level_one_ou.accounts, []) : merge(account, { parent_id : aws_organizations_organizational_unit.level_one[level_one_ou.name].id })]
  ])
  level_two_accounts = flatten([
    for level_two_ou in local.level_two_ous : [for account in try(level_two_ou.accounts, []) : merge(account, { parent_id : aws_organizations_organizational_unit.level_two[level_two_ou.key].id })]
  ])
  level_three_accounts = flatten([
    for level_three_ou in local.level_three_ous : [for account in try(level_three_ou.accounts, []) : merge(account, { parent_id : level_three_ou.parent_id })]
  ])
  accounts = concat(local.level_one_accounts, local.level_two_accounts, local.level_three_accounts)
  level_two_ous = flatten([
    for level_one_ou in var.organizational_units : [
      for level_two_ou in try(level_one_ou.organizational_units, []) : {
        ou : level_two_ou
        key : "${level_one_ou.name}-${level_two_ou.name}"
        parent_id : aws_organizations_organizational_unit.level_one[level_one_ou.name].id
      }
    ]
  ])
  level_three_ous = flatten([
    for level_one_ou in var.organizational_units : [
      for level_two_ou in try(level_one_ou.organizational_units, []) : [
        for level_three_ou in try(level_two_ou.organizational_units, []) : {
          ou : level_three_ou
          key : "${level_one_ou.name}-${level_two_ou.name}-${level_three_ou.name}"
          parent_id : aws_organizations_organizational_unit.level_two["${level_one_ou.name}-${level_two_ou.name}"].id
        }
      ]
    ]
  ])

  ous = merge(aws_organizations_organizational_unit.level_one, aws_organizations_organizational_unit.level_two, aws_organizations_organizational_unit.level_three)

  delegated_administrators = flatten([
    for account in local.accounts : [
      for service in account.delegated_administrator_services : { service_principal : service, account_name : account.name }
    ]
  ])

  delegated_service_principals = flatten([
    for account in local.accounts : [
      for service in account.delegated_administrator_services : service
    ]
  ])

  organizations_policy_attachments = flatten([
    for name, policy in var.organizations_policies : [
      for ou in policy.ous : {
        target_id : ou == "root" ? aws_organizations_organization.default.roots[0].id : local.ous[ou]
        policy_id : aws_organizations_policy.default[name]
      }
    ]
  ])
}

resource "aws_organizations_organizational_unit" "level_two" {
  for_each = {
    for ou in local.level_two_ous : ou.key => ou
  }

  name      = each.value.ou.name
  parent_id = each.value.parent_id
  tags      = merge(var.tags, each.value.ou.tags)
}

resource "aws_organizations_organizational_unit" "level_three" {
  for_each = {
    for ou in local.level_three_ous : ou.key => ou
  }

  name      = each.value.ou.name
  parent_id = each.value.parent_id
  tags      = merge(var.tags, each.value.ou.tags)
}

resource "aws_organizations_account" "default" {
  for_each = {
    for account in local.accounts : account.name => account
  }

  name                       = each.value.name
  email                      = each.value.email
  close_on_deletion          = try(each.value.close_on_deletion, null)
  iam_user_access_to_billing = try(each.value.iam_user_access_to_billing, null)
  parent_id                  = each.value.parent_id
  tags                       = merge(var.tags, try(each.value.tags, {}))
  depends_on                 = [aws_organizations_organization.default]
}

resource "aws_organizations_delegated_administrator" "default" {
  for_each = {
    for account in local.delegated_administrators : account.service_principal => account
  }

  account_id        = aws_organizations_account.default[each.value.account_name].id
  service_principal = each.value.service_principal
}

resource "aws_organizations_policy" "default" {
  for_each = var.organizations_policies

  name         = each.key
  content      = each.value.content
  description  = try(each.value.description, null)
  skip_destroy = try(each.value.skip_destroy, null)
  type         = try(each.value.type, "SERVICE_CONTROL_POLICY")
  tags         = var.tags
  depends_on   = [aws_organizations_organization.default]
}

resource "aws_organizations_policy_attachment" "default" {
  for_each = {
    for attachment in local.organizations_policy_attachments : "${attachment.policy_id}-${attachment.target_id}" => attachment
  }

  policy_id  = each.value.policy_id
  target_id  = each.value.target_id
  depends_on = [aws_organizations_organization.default]
}

### Account Management
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

### Child Account Management
resource "aws_account_primary_contact" "child" {
  for_each = {
    for account in local.accounts : account.name => account
  }

  account_id         = aws_organizations_account.default[each.key].id
  address_line_1     = var.primary_contact.address_line_1
  address_line_2     = try(var.primary_contact.address_line_2, null)
  address_line_3     = try(var.primary_contact.address_line_3, null)
  city               = var.primary_contact.city
  company_name       = try(var.primary_contact.company_name, null)
  country_code       = var.primary_contact.country_code
  district_or_county = try(var.primary_contact.district_or_county, null)
  full_name          = var.primary_contact.full_name
  phone_number       = var.primary_contact.phone_number
  postal_code        = var.primary_contact.postal_code
  state_or_region    = try(var.primary_contact.state_or_region, null)
  website_url        = try(var.primary_contact.website_url, null)
}

resource "aws_account_alternate_contact" "child_operations" {
  for_each = {
    for account in local.accounts : account.name => account
  }

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "OPERATIONS"

  name          = try(var.operations_contact.name, var.primary_contact.full_name)
  title         = var.operations_contact.title
  email_address = var.operations_contact.email_address
  phone_number  = try(var.operations_contact.phone_number, var.primary_contact.phone_number)
}

resource "aws_account_alternate_contact" "child_billing" {
  for_each = {
    for account in local.accounts : account.name => account
  }

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "BILLING"

  name          = try(var.billing_contact.name, var.primary_contact.full_name)
  title         = var.billing_contact.title
  email_address = var.billing_contact.email_address
  phone_number  = try(var.billing_contact.phone_number, var.primary_contact.phone_number)
}

resource "aws_account_alternate_contact" "child_security" {
  for_each = {
    for account in local.accounts : account.name => account
  }

  account_id             = aws_organizations_account.default[each.key].id
  alternate_contact_type = "SECURITY"

  name          = try(var.security_contact.name, var.primary_contact.full_name)
  title         = var.security_contact.title
  email_address = var.security_contact.email_address
  phone_number  = try(var.security_contact.phone_number, var.primary_contact.phone_number)
}


### Securityhub organization settings
resource "aws_securityhub_organization_admin_account" "default" {
  count = contains(local.delegated_service_principals, "securityhub.amazonaws.com") ? 1 : 0

  admin_account_id = aws_organizations_delegated_administrator.default["securityhub.amazonaws.com"].account_id
  depends_on       = [aws_organizations_organization.default]
}

### GuardDuty organization settings
resource "aws_guardduty_detector" "default" {
  count = contains(local.delegated_service_principals, "guardduty.amazonaws.com") != "" ? 1 : 0
}

resource "aws_guardduty_organization_admin_account" "default" {
  count = contains(local.delegated_service_principals, "guardduty.amazonaws.com") != "" ? 1 : 0

  admin_account_id = aws_organizations_delegated_administrator.default["guardduty.amazonaws.com"].account_id
  depends_on       = [aws_organizations_organization.default, aws_guardduty_detector.default[0]]
}

### Inspector organization settings
resource "aws_inspector2_delegated_admin_account" "default" {
  count = contains(local.delegated_service_principals, "inspector2.amazonaws.com") ? 1 : 0

  account_id = aws_organizations_delegated_administrator.default["inspector2.amazonaws.com"].account_id
}
