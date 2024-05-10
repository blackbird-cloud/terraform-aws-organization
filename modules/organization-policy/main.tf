
locals {
  organizations_policy_attachments = flatten([
    for name, policy in var.organizations_policies : [
      for ou in policy.ous : {
        ou          = ou
        policy_name = name
      }
    ]
  ])
}

resource "aws_organizations_policy" "default" {
  for_each = var.organizations_policies

  name         = each.key
  content      = each.value.content
  description  = try(each.value.description, null)
  skip_destroy = try(each.value.skip_destroy, null)
  type         = try(each.value.type, "SERVICE_CONTROL_POLICY")
  tags         = var.tags
}

resource "aws_organizations_policy_attachment" "default" {
  for_each = {
    for attachment in local.organizations_policy_attachments : "${attachment.policy_name}-${attachment.ou}" => attachment
  }

  policy_id  = aws_organizations_policy.default[each.value.policy_name].id
  target_id  = each.value.ou
  depends_on = [aws_organizations_policy.default]
}
