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
  type        = map(any)
  description = "Tree of Organization Units, supporting three levels deep. { ou1 :{ ou2: {ou3: {} }} }"
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

variable "accounts" {
  type        = list(any)
  default     = []
  description = "List of AWS accounts to create, name,email, close_on_deletion, iam_user_access_to_billing, ou_name, and delegated_administrator_services are the configurable options."
}
