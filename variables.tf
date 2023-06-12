variable "aws_service_access_principals" {
  type        = list(string)
  description = "(Optional) List of AWS service principal names for which you want to enable integration with your organization. This is typically in the form of a URL, such as service-abbreviation.amazonaws.com. Organization must have feature_set set to ALL. Some services do not support enablement via this endpoint, see warning in aws docs. https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html"
}

variable "enabled_policy_types" {
  type        = list(string)
  description = "(Optional) List of Organizations policy types to enable in the Organization Root. Organization must have feature_set set to ALL. For additional information about valid policy types (e.g., AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, SERVICE_CONTROL_POLICY, and TAG_POLICY), see the AWS Organizations API Reference."
}

variable "feature_set" {
  type        = string
  description = "(Optional) Specify \"ALL\" (default) or \"CONSOLIDATED_BILLING\"."
}

variable "organizational_units" {
  type        = list(any)
  description = <<EOF
List of Organizational units configuration, plus sub accounts. Organizational units can be nested 3 levels deep.
`[{
    name = string
    accounts: [{
        name = string,
        email = string,
        close_on_deletion = bool,
        iam_user_access_to_billing= bool,
        delegated_administrator_services = list(string)
        tags = map(string)
    }]
    organizational_units: list(ou)
    tags : map(string)
}]`
EOF
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Key-value map of resource tags. If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}

variable "organizations_policies" {
  type        = map(any)
  default     = {}
  description = "Map of policies to attach to your organization. Key will be used as policy name, provide the stringified JSON at at the key `content` in the value of the map."
}

# variable "accounts" {
#   type        = list(any)
#   default     = []
#   description = "List of AWS accounts to create, name,email, close_on_deletion, iam_user_access_to_billing, ou_name, and delegated_administrator_services are the configurable options."
# }

variable "primary_contact" {
  type        = any
  description = "address_line_1 - (Required) The first line of the primary contact address. address_line_2 - (Optional) The second line of the primary contact address, if any. address_line_3 - (Optional) The third line of the primary contact address, if any. city - (Required) The city of the primary contact address. company_name - (Optional) The name of the company associated with the primary contact information, if any. country_code - (Required) The ISO-3166 two-letter country code for the primary contact address. district_or_county - (Optional) The district or county of the primary contact address, if any. full_name - (Required) The full name of the primary contact address. phone_number - (Required) The phone number of the primary contact information. The number will be validated and, in some countries, checked for activation. postal_code - (Required) The postal code of the primary contact address. state_or_region - (Optional) The state or region of the primary contact address. This field is required in selected countries. website_url - (Optional) The URL of the website associated with the primary contact information, if any."
}

variable "billing_contact" {
  type        = any
  description = "email_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact."
}

variable "security_contact" {
  type        = any
  description = "email_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact."
}

variable "operations_contact" {
  type        = any
  description = "email_address - (Required) An email address for the alternate contact. name - (Required) Name of the alternate contact. phone_number - (Required) Phone number for the alternate contact. title - (Required) Title for the alternate contact."
}
