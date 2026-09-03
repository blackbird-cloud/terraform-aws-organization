# AWS Organizations Terraform module
A Terraform module which configures your AWS Organization and creates AWS accounts. Read [this](https://docs.aws.amazon.com/organizations/index.html) page for more information, and for a secure reference architecture by AWS, read [this](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/welcome.html) page.

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://www.blackbird.cloud)

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.52.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_account_alternate_contact.root_billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.root_operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.root_security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_primary_contact.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_primary_contact) | resource |
| [aws_organizations_organization.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_ram_sharing_with_organization.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_sharing_with_organization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aws_ram_sharing_with_organization"></a> [aws\_ram\_sharing\_with\_organization](#input\_aws\_ram\_sharing\_with\_organization) | (Optional) Enable resource sharing with AWS RAM across the organization. This allows you to share resources across accounts in your organization. | `bool` | `false` | no |
| <a name="input_aws_service_access_principals"></a> [aws\_service\_access\_principals](#input\_aws\_service\_access\_principals) | (Optional) List of AWS service principal names for which you want to enable integration with your organization. This is typically in the form of a URL, such as service-abbreviation.amazonaws.com. Organization must have feature\_set set to ALL. Some services do not support enablement via this endpoint, see warning in aws docs. https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html | `list(string)` | `[]` | no |
| <a name="input_billing_contact"></a> [billing\_contact](#input\_billing\_contact) | (Optional) Billing alternate contact for the management account. Set to null to leave it unmanaged by Terraform. | <pre>object({<br/>    name          = string<br/>    title         = string<br/>    email_address = string<br/>    phone_number  = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | (Optional) List of Organizations policy types to enable in the Organization Root. Organization must have feature\_set set to ALL. For additional information about valid policy types (e.g., AISERVICES\_OPT\_OUT\_POLICY, BACKUP\_POLICY, SERVICE\_CONTROL\_POLICY, and TAG\_POLICY), see the AWS Organizations API Reference. | `list(string)` | `[]` | no |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | (Optional) Specify "ALL" (default) or "CONSOLIDATED\_BILLING". | `string` | `"ALL"` | no |
| <a name="input_operations_contact"></a> [operations\_contact](#input\_operations\_contact) | (Optional) Operations alternate contact for the management account. Set to null to leave it unmanaged by Terraform. | <pre>object({<br/>    name          = string<br/>    title         = string<br/>    email_address = string<br/>    phone_number  = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_primary_contact"></a> [primary\_contact](#input\_primary\_contact) | (Optional) Primary contact information for the management account. Set to null to leave the contact unmanaged by Terraform. | <pre>object({<br/>    address_line_1     = string<br/>    address_line_2     = optional(string)<br/>    address_line_3     = optional(string)<br/>    city               = string<br/>    company_name       = optional(string)<br/>    country_code       = string<br/>    district_or_county = optional(string)<br/>    full_name          = string<br/>    phone_number       = string<br/>    postal_code        = string<br/>    state_or_region    = optional(string)<br/>    website_url        = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_security_contact"></a> [security\_contact](#input\_security\_contact) | (Optional) Security alternate contact for the management account. Set to null to leave it unmanaged by Terraform. | <pre>object({<br/>    name          = string<br/>    title         = string<br/>    email_address = string<br/>    phone_number  = optional(string)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_contacts"></a> [contacts](#output\_contacts) | The contacts for the organization management account |
| <a name="output_organization"></a> [organization](#output\_organization) | The full AWS Organization resource |
| <a name="output_organization_id"></a> [organization\_id](#output\_organization\_id) | The ID of the organization |
| <a name="output_organization_root_id"></a> [organization\_root\_id](#output\_organization\_root\_id) | The ID of the organization root |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://www.blackbird.cloud)