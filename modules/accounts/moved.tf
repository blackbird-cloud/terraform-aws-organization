# Renamed the IPAM delegated-admin resource from "example" to "default" for
# consistency with the other resources in this module.
moved {
  from = aws_vpc_ipam_organization_admin_account.example
  to   = aws_vpc_ipam_organization_admin_account.default
}
