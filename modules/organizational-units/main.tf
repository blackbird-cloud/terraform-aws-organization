resource "aws_organizations_organizational_unit" "default" {
  for_each = var.organization_units

  name      = each.value.name
  parent_id = each.value.parent_id
  tags      = each.value.tags
}