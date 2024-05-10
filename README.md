# AWS Organizations Terraform module
A Terraform module which configures your AWS Organization and creates AWS accounts. Read [this](https://docs.aws.amazon.com/organizations/index.html) page for more information, and for a secure reference architecture by AWS, read [this](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html) page.

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://www.blackbird.cloud)

## Example
```hcl
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
```

# AWS Organizations Terraform module
A Terraform module which configures your AWS Organization and creates AWS accounts. Read [this](https://docs.aws.amazon.com/organizations/index.html) page for more information, and for a secure reference architecture by AWS, read [this](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html) page.

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://www.blackbird.cloud)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |

## Resources

| Name | Type |
|------|------|
| [aws_account_alternate_contact.billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_primary_contact.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_primary_contact) | resource |
| [aws_organizations_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_delegated_administrator.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts"></a> [accounts](#input\_accounts) | List of AWS accounts to create | <pre>map(object({<br>    email                            = string<br>    close_on_deletion                = optional(bool)<br>    iam_user_access_to_billing       = optional(bool)<br>    delegated_administrator_services = list(string)<br>    tags                             = optional(map(string))<br>    parent_id                        = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_contacts"></a> [contacts](#input\_contacts) | Primary and alternate contacts for the accounts | <pre>object({<br>    primary_contact = object({<br>      address_line_1     = string<br>      address_line_2     = optional(string)<br>      address_line_3     = optional(string)<br>      city               = string<br>      company_name       = optional(string)<br>      country_code       = string<br>      district_or_county = optional(string)<br>      full_name          = string<br>      phone_number       = string<br>      postal_code        = string<br>      state_or_region    = optional(string)<br>      website_url        = optional(string)<br>    })<br>    operations_contact = object({<br>      name          = string<br>      title         = string<br>      email_address = string<br>      phone_number  = optional(string)<br>    })<br>    billing_contact = object({<br>      name          = string<br>      title         = string<br>      email_address = string<br>      phone_number  = optional(string)<br>    })<br>    security_contact = object({<br>      name          = string<br>      title         = string<br>      email_address = string<br>      phone_number  = optional(string)<br>    })<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounts"></a> [accounts](#output\_accounts) | The accounts created |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)
# AWS Organizations Terraform module
A Terraform module which configures your AWS Organization and creates AWS accounts. Read [this](https://docs.aws.amazon.com/organizations/index.html) page for more information, and for a secure reference architecture by AWS, read [this](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html) page.

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://www.blackbird.cloud)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |

## Resources

| Name | Type |
|------|------|
| [aws_account_alternate_contact.root_billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.root_operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.root_security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_primary_contact.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_primary_contact) | resource |
| [aws_organizations_organization.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_service_access_principals"></a> [aws\_service\_access\_principals](#input\_aws\_service\_access\_principals) | (Optional) List of AWS service principal names for which you want to enable integration with your organization. This is typically in the form of a URL, such as service-abbreviation.amazonaws.com. Organization must have feature\_set set to ALL. Some services do not support enablement via this endpoint, see warning in aws docs. https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html | `list(string)` | n/a | yes |
| <a name="input_billing_contact"></a> [billing\_contact](#input\_billing\_contact) | email\_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone\_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact. | `any` | n/a | yes |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | (Optional) List of Organizations policy types to enable in the Organization Root. Organization must have feature\_set set to ALL. For additional information about valid policy types (e.g., AISERVICES\_OPT\_OUT\_POLICY, BACKUP\_POLICY, SERVICE\_CONTROL\_POLICY, and TAG\_POLICY), see the AWS Organizations API Reference. | `list(string)` | `[]` | no |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | (Optional) Specify "ALL" (default) or "CONSOLIDATED\_BILLING". | `string` | n/a | yes |
| <a name="input_operations_contact"></a> [operations\_contact](#input\_operations\_contact) | email\_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone\_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact. | `any` | n/a | yes |
| <a name="input_primary_contact"></a> [primary\_contact](#input\_primary\_contact) | address\_line\_1 - (Required) The first line of the primary contact address. address\_line\_2 - (Optional) The second line of the primary contact address, if any. address\_line\_3 - (Optional) The third line of the primary contact address, if any. city - (Required) The city of the primary contact address. company\_name - (Optional) The name of the company associated with the primary contact information, if any. country\_code - (Required) The ISO-3166 two-letter country code for the primary contact address. district\_or\_county - (Optional) The district or county of the primary contact address, if any. full\_name - (Required) The full name of the primary contact address. phone\_number - (Required) The phone number of the primary contact information. The number will be validated and, in some countries, checked for activation. postal\_code - (Required) The postal code of the primary contact address. state\_or\_region - (Optional) The state or region of the primary contact address. This field is required in selected countries. website\_url - (Optional) The URL of the website associated with the primary contact information, if any. | `any` | n/a | yes |
| <a name="input_security_contact"></a> [security\_contact](#input\_security\_contact) | email\_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone\_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_contacts"></a> [contacts](#output\_contacts) | The contacts for the organization |
| <a name="output_organization_root_id"></a> [organization\_root\_id](#output\_organization\_root\_id) | The ID of the organization root |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)
# AWS Organizations Terraform module
A Terraform module which configures your AWS Organization and creates AWS accounts. Read [this](https://docs.aws.amazon.com/organizations/index.html) page for more information, and for a secure reference architecture by AWS, read [this](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html) page.

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://www.blackbird.cloud)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organizations_policies"></a> [organizations\_policies](#input\_organizations\_policies) | A map of policies to attach to the organization | <pre>map(object({<br>    content      = string<br>    ous          = list(string)<br>    description  = optional(string)<br>    skip_destroy = optional(bool)<br>    type         = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policies"></a> [policies](#output\_policies) | The policies for the organization |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)
# AWS Organizations Terraform module
A Terraform module which configures your AWS Organization and creates AWS accounts. Read [this](https://docs.aws.amazon.com/organizations/index.html) page for more information, and for a secure reference architecture by AWS, read [this](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html) page.

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://www.blackbird.cloud)


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organizational_unit.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organization_units"></a> [organization\_units](#input\_organization\_units) | List of organizational units to create | <pre>map(object(<br>    {<br>      name      = string<br>      parent_id = string<br>      tags      = optional(map(string))<br>    }<br>  ))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ous"></a> [ous](#output\_ous) | The organizational units for the organization |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)