resource "aws_organizations_organization" "default" {
  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set
}

resource "aws_organizations_organizational_unit" "level_one" {
  for_each = var.organizational_units

  name      = each.key
  parent_id = aws_organizations_organization.default.roots[0].id
  tags      = var.tags
}

locals {
  level_two_ous = flatten([
    for ou, level_two_children in var.organizational_units : [
      for level_two_ou, level_three_children in level_two_children : {
        ou : level_two_ou
        parent_id : aws_organizations_organizational_unit.level_one[ou].id
      }
    ]
  ])
  level_three_ous = flatten([
    for ou, level_two_children in var.organizational_units : [
      for level_two_ou, level_three_children in level_two_children : [
        for level_three_ou, level_four_children in level_three_children : {
          ou : level_three_ou
          parent_id : aws_organizations_organizational_unit.level_two[level_two_ou].id
        }
      ]
    ]
  ])
  ous                      = merge(aws_organizations_organizational_unit.level_one, aws_organizations_organizational_unit.level_two, aws_organizations_organizational_unit.level_three)
  delegated_administrators = flatten(compact([for account in var.accounts : try(account.delegated_administrator_services, "") != "" ? [for service_principal in account.delegated_administrator_services : merge(account, { service_principal : service_principal })] : null]))
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
    for ou in local.level_two_ous : ou.ou => ou
  }

  name      = each.key
  parent_id = each.value.parent_id
  tags      = var.tags
}

resource "aws_organizations_organizational_unit" "level_three" {
  for_each = {
    for ou in local.level_three_ous : ou.ou => ou
  }

  name      = each.key
  parent_id = each.value.parent_id
  tags      = var.tags
}

resource "aws_organizations_account" "default" {
  for_each = {
    for account in var.accounts : account.name => account
  }
  name                       = each.key
  email                      = each.value.email
  close_on_deletion          = try(each.value.close_on_deletion)
  iam_user_access_to_billing = try(each.value.iam_user_access_to_billing)
  parent_id                  = try(each.value.ou_name)
  tags                       = var.tags
}

resource "aws_organizations_delegated_administrator" "default" {
  for_each = {
    for account in local.delegated_administrators : account.name => account
  }
  account_id        = aws_organizations_account.default[each.key]
  service_principal = each.value.service_principal
}

resource "aws_organizations_policy" "default" {
  for_each = var.organizations_policies

  name         = each.key
  content      = each.value.content
  description  = try(each.value.description, null)
  skip_destroy = try(each.value.skip_destroy, null)
  type         = try(each.value.skip_destroy, "SERVICE_CONTROL_POLICY")
  tags         = var.tags
}

resource "aws_organizations_policy_attachment" "default" {
  for_each = {
    for attachment in local.organizations_policy_attachments : "${attachment.policy_id}-${attachment.target_id}" => attachment
  }

  policy_id = each.value.policy_id
  target_id = each.value.target_id
}
