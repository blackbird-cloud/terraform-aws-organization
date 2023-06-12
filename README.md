[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://blackbird.cloud)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_account_alternate_contact.child_billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.child_operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.child_security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.root_billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.root_operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.root_security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_primary_contact.child](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_primary_contact) | resource |
| [aws_account_primary_contact.root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_primary_contact) | resource |
| [aws_guardduty_detector.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_organization_admin_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_admin_account) | resource |
| [aws_organizations_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_delegated_administrator.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_organization.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.level_one](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.level_three](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.level_two](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_securityhub_organization_admin_account.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_admin_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_service_access_principals"></a> [aws\_service\_access\_principals](#input\_aws\_service\_access\_principals) | (Optional) List of AWS service principal names for which you want to enable integration with your organization. This is typically in the form of a URL, such as service-abbreviation.amazonaws.com. Organization must have feature\_set set to ALL. Some services do not support enablement via this endpoint, see warning in aws docs. https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html | `list(string)` | n/a | yes |
| <a name="input_billing_contact"></a> [billing\_contact](#input\_billing\_contact) | email\_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone\_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact. | `any` | n/a | yes |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | (Optional) List of Organizations policy types to enable in the Organization Root. Organization must have feature\_set set to ALL. For additional information about valid policy types (e.g., AISERVICES\_OPT\_OUT\_POLICY, BACKUP\_POLICY, SERVICE\_CONTROL\_POLICY, and TAG\_POLICY), see the AWS Organizations API Reference. | `list(string)` | n/a | yes |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | (Optional) Specify "ALL" (default) or "CONSOLIDATED\_BILLING". | `string` | n/a | yes |
| <a name="input_operations_contact"></a> [operations\_contact](#input\_operations\_contact) | email\_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone\_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact. | `any` | n/a | yes |
| <a name="input_organizational_units"></a> [organizational\_units](#input\_organizational\_units) | List of Organizational units configuration, plus sub accounts. Organizational units can be nested 3 levels deep.<br>`[{<br>    name = string<br>    accounts: [{<br>        name = string,<br>        email = string,<br>        close_on_deletion = bool,<br>        iam_user_access_to_billing= bool,<br>        delegated_administrator_services = list(string)<br>        tags = map(string)<br>    }]<br>    organizational_units: list(ou)<br>    tags : map(string)<br>}]` | `list(any)` | n/a | yes |
| <a name="input_organizations_policies"></a> [organizations\_policies](#input\_organizations\_policies) | Map of policies to attach to your organization. Key will be used as policy name, provide the stringified JSON at at the key `content` in the value of the map. | `map(any)` | `{}` | no |
| <a name="input_primary_contact"></a> [primary\_contact](#input\_primary\_contact) | address\_line\_1 - (Required) The first line of the primary contact address. address\_line\_2 - (Optional) The second line of the primary contact address, if any. address\_line\_3 - (Optional) The third line of the primary contact address, if any. city - (Required) The city of the primary contact address. company\_name - (Optional) The name of the company associated with the primary contact information, if any. country\_code - (Required) The ISO-3166 two-letter country code for the primary contact address. district\_or\_county - (Optional) The district or county of the primary contact address, if any. full\_name - (Required) The full name of the primary contact address. phone\_number - (Required) The phone number of the primary contact information. The number will be validated and, in some countries, checked for activation. postal\_code - (Required) The postal code of the primary contact address. state\_or\_region - (Optional) The state or region of the primary contact address. This field is required in selected countries. website\_url - (Optional) The URL of the website associated with the primary contact information, if any. | `any` | n/a | yes |
| <a name="input_security_contact"></a> [security\_contact](#input\_security\_contact) | email\_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone\_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Key-value map of resource tags. If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accounts"></a> [accounts](#output\_accounts) | All AWS accounts. |
| <a name="output_organization"></a> [organization](#output\_organization) | The AWS Organization |
| <a name="output_organizational_units"></a> [organizational\_units](#output\_organizational\_units) | All AWS Organizational Units. |
| <a name="output_organizations_delegated_administrator"></a> [organizations\_delegated\_administrator](#output\_organizations\_delegated\_administrator) | The AWS Organization delegated administrator assignments. |
| <a name="output_organizations_policies"></a> [organizations\_policies](#output\_organizations\_policies) | The created Organization policies. |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2023 [Blackbird Cloud](https://blackbird.cloud)
