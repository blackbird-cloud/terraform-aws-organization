output "accounts" {
  description = "The created AWS accounts, keyed by account name (id, arn, name, email, parent_id, state, joined_method, joined_timestamp, tags)"
  # Curated instead of the raw resource: the resource's `status` attribute is deprecated in AWS provider 6
  # (replaced by `state`) and exposing it would raise a deprecation warning for every consumer.
  value = {
    for name, account in aws_organizations_account.default : name => {
      id               = account.id
      arn              = account.arn
      name             = account.name
      email            = account.email
      parent_id        = account.parent_id
      state            = account.state
      joined_method    = account.joined_method
      joined_timestamp = account.joined_timestamp
      tags             = account.tags
    }
  }
}

output "delegated_administrators" {
  description = "The Organizations delegated administrator registrations, keyed by \"<account>-<service_principal>\""
  value       = aws_organizations_delegated_administrator.default
}
