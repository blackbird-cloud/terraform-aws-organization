variable "aws_service_access_principals" {
  type        = list(string)
  description = "(Optional) List of AWS service principal names for which you want to enable integration with your organization. This is typically in the form of a URL, such as service-abbreviation.amazonaws.com. Organization must have feature_set set to ALL. Some services do not support enablement via this endpoint, see warning in aws docs. https://docs.aws.amazon.com/organizations/latest/userguide/orgs_integrate_services_list.html"
  default     = []
}

variable "enabled_policy_types" {
  type        = list(string)
  description = "(Optional) List of Organizations policy types to enable in the Organization Root. Organization must have feature_set set to ALL. For additional information about valid policy types (e.g., AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, SERVICE_CONTROL_POLICY, and TAG_POLICY), see the AWS Organizations API Reference."
  default     = []
}

variable "feature_set" {
  type        = string
  description = "(Optional) Specify \"ALL\" (default) or \"CONSOLIDATED_BILLING\"."
  default     = "ALL"

  validation {
    condition     = contains(["ALL", "CONSOLIDATED_BILLING"], var.feature_set)
    error_message = "feature_set must be one of \"ALL\" or \"CONSOLIDATED_BILLING\"."
  }
}

variable "primary_contact" {
  description = "(Optional) Primary contact information for the management account. Set to null to leave the contact unmanaged by Terraform."
  default     = null
  type = object({
    address_line_1     = string
    address_line_2     = optional(string)
    address_line_3     = optional(string)
    city               = string
    company_name       = optional(string)
    country_code       = string
    district_or_county = optional(string)
    full_name          = string
    phone_number       = string
    postal_code        = string
    state_or_region    = optional(string)
    website_url        = optional(string)
  })
}

variable "operations_contact" {
  description = "(Optional) Operations alternate contact for the management account. Set to null to leave it unmanaged by Terraform."
  default     = null
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = optional(string)
  })
}

variable "billing_contact" {
  description = "(Optional) Billing alternate contact for the management account. Set to null to leave it unmanaged by Terraform."
  default     = null
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = optional(string)
  })
}

variable "security_contact" {
  description = "(Optional) Security alternate contact for the management account. Set to null to leave it unmanaged by Terraform."
  default     = null
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = optional(string)
  })
}

variable "aws_ram_sharing_with_organization" {
  type        = bool
  description = "(Optional) Enable resource sharing with AWS RAM across the organization. This allows you to share resources across accounts in your organization."
  default     = false
}
