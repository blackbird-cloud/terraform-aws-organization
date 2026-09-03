<!-- BEGIN_TF_DOCS -->
# Terraform Aws Organization Module
Terraform module to create an AWS Organization

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://blackbird.cloud)

## Example
```hcl
locals {
  tags = {
    ManagedBy = "Terraform"
    Module    = "terraform-aws-organization"
  }
}

module "organization" {
  source = "../modules/organization"

  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "account.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com",
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
  source = "../modules/organizational-units"

  organization_units = {
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
  source = "../modules/accounts"

  tags     = local.tags
  contacts = module.organization.contacts

  accounts = {
    keys = {
      email     = "keys@example.com"
      parent_id = module.organization_units.ous["Security"].id
    }
    logs = {
      email     = "logs@example.com"
      parent_id = module.organization_units.ous["Security"].id
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Firewall Manager administrator: AWS only accepts the association in us-east-1.
module "fms_admin" {
  source    = "../modules/fms-admin"
  providers = { aws = aws.us_east_1 }

  account_id = module.accounts.accounts["logs"].id
}

module "org_policies" {
  source = "../modules/organization-policy"

  tags = local.tags

  organizations_policies = {
    "ServiceControlPolicy" = {
      description = "Baseline service control policy"
      type        = "SERVICE_CONTROL_POLICY"
      ous         = [module.organization.organization_root_id]
      content = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid      = "DenyLeavingOrganization"
            Effect   = "Deny"
            Action   = "organizations:LeaveOrganization"
            Resource = "*"
          }
        ]
      })
    }
  }
}
```

## Modules

- [Accounts](./modules/accounts/README.md)
- [FMS Admin](./modules/fms-admin/README.md)
- [Organization](./modules/organization/README.md)
- [Organization Policy](./modules/organization-policy/README.md)
- [Organizational Units](./modules/organizational-units/README.md)

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2025 [Blackbird Cloud](https://blackbird.cloud)
<!-- END_TF_DOCS -->