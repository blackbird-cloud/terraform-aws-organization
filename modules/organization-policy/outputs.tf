output "policies" {
  description = "The policies for the organization"
  value       = aws_organizations_policy.default
}