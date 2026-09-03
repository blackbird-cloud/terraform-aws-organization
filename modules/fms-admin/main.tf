# AWS Firewall Manager only accepts AssociateAdminAccount in us-east-1, so this lives in its own
# module: pass a us-east-1 provider, e.g. `providers = { aws = aws.us_east_1 }`.
resource "aws_fms_admin_account" "default" {
  account_id = var.account_id
}
