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
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5 |

## Resources

| Name | Type |
|------|------|
| [aws_account_alternate_contact.billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_primary_contact.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_primary_contact) | resource |
| [aws_guardduty_detector.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_organization_admin_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_admin_account) | resource |
| [aws_inspector2_delegated_admin_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/inspector2_delegated_admin_account) | resource |
| [aws_organizations_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_delegated_administrator.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_securityhub_organization_admin_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_admin_account) | resource |
| [aws_vpc_ipam_organization_admin_account.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_organization_admin_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts"></a> [accounts](#input\_accounts) | List of AWS accounts to create | <pre>map(object({<br>    email                            = string<br>    close_on_deletion                = optional(bool)<br>    iam_user_access_to_billing       = optional(string)<br>    delegated_administrator_services = list(string)<br>    tags                             = optional(map(string))<br>    parent_id                        = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_contacts"></a> [contacts](#input\_contacts) | Primary and alternate contacts for the accounts | <pre>object({<br>    primary_contact = object({<br>      address_line_1     = string<br>      address_line_2     = optional(string)<br>      address_line_3     = optional(string)<br>      city               = string<br>      company_name       = optional(string)<br>      country_code       = string<br>      district_or_county = optional(string)<br>      full_name          = string<br>      phone_number       = string<br>      postal_code        = string<br>      state_or_region    = optional(string)<br>      website_url        = optional(string)<br>    })<br>    operations_contact = object({<br>      name          = string<br>      title         = string<br>      email_address = string<br>      phone_number  = optional(string)<br>    })<br>    billing_contact = object({<br>      name          = string<br>      title         = string<br>      email_address = string<br>      phone_number  = optional(string)<br>    })<br>    security_contact = object({<br>      name          = string<br>      title         = string<br>      email_address = string<br>      phone_number  = optional(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounts"></a> [accounts](#output\_accounts) | The accounts created |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)
