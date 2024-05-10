module "organization" {
  source  = "../modules/organization"
  version = "~> 3"

  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "account.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com"
  ]
  enabled_policy_types = ["BACKUP_POLICY", "SERVICE_CONTROL_POLICY", "TAG_POLICY"]
  feature_set          = "ALL"

  primary_contact = {
    address_line_1  = "123 Main St"
    city            = "Anytown"
    country_code    = "US"
    full_name       = "John Doe"
    phone_number    = "+1-555-555-5555"
    postal_code     = "12345"
    state_or_region = "WA"
  }

  billing_contact = {
    name          = "Jane Doe"
    title         = "Billing"
    email_address = "billing@example.com"
  }

  operations_contact = {
    name          = "Jane Doe"
    title         = "Operations"
    email_address = "ops@example.com"
  }

  security_contact = {
    name          = "Jane Doe"
    title         = "Security"
    email_address = "security@example.com"
  }
}

module "organization_units" {
  source  = "../modules/organization-units"
  version = "~> 3"

  organizations_units = {
    "Development" = {
      parent_id = module.organization.organization_root_id
    }
    "Operations" = {
      parent_id = module.organization.organization_root_id
    }
    "Security" = {
      parent_id = module.organization.organization_root_id
    }
  }
}

module "accounts" {
  source  = "../modules/accounts"
  version = "~> 3"

  contacts = dependency.org.outputs.contacts
  accounts = {
    keys = {
      email                            = "keys@example.com"
      delegated_administrator_services = []
      parent_id                        = dependency.ous.outputs.ous["security"].id
    }
    logs = {
      email                            = "logs@example.com"
      delegated_administrator_services = []
      parent_id                        = dependency.ous.outputs.ous["security"].id
    }
  }
}

module "org_policies" {
  source  = "../modules/org-policies"
  version = "~> 3"

  organizations_policies = {
    "BackupPolicy" = {
      description = "Backup policy"
      policy      = file("${path.module}/policies/backup_policy.json")
      target_id   = module.organization.organization_root_id
      type        = "BACKUP_POLICY"
    }
    "ServiceControlPolicy" = {
      description = "Service control policy"
      policy      = file("${path.module}/policies/service_control_policy.json")
      target_id   = module.organization.organization_root_id
      type        = "SERVICE_CONTROL_POLICY"
    }
    "TagPolicy" = {
      description = "Tag policy"
      policy      = file("${path.module}/policies/tag_policy.json")
      target_id   = module.organization.organization_root_id
      type        = "TAG_POLICY"
    }
  }
}