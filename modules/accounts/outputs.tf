

# output "account" {
#   description = "The account object"
#   value = {
#     name  = aws_organizations_account.default.name
#     email = aws_organizations_account.default.email
#     arn   = aws_organizations_account.default.arn
#     id    = aws_organizations_account.default.id
#   }
# }

output "accounts" {
  description = "The accounts created"
  value       = aws_organizations_account.default
}