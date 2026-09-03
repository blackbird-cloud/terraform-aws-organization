variable "accounts" {
  description = "List of AWS accounts to create"
  type = map(object({
    email                            = string
    close_on_deletion                = optional(bool)
    iam_user_access_to_billing       = optional(bool)
    delegated_administrator_services = optional(list(string), [])
    tags                             = optional(map(string), {})
    parent_id                        = optional(string)
  }))
}

variable "contacts" {
  description = "(Optional) Primary and alternate contacts to apply to every created account. Set to null to leave account contacts unmanaged by Terraform. Each alternate contact (operations/billing/security) can be omitted individually."
  default     = null
  type = object({
    primary_contact = object({
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
    operations_contact = optional(object({
      name          = string
      title         = string
      email_address = string
      phone_number  = optional(string)
    }))
    billing_contact = optional(object({
      name          = string
      title         = string
      email_address = string
      phone_number  = optional(string)
    }))
    security_contact = optional(object({
      name          = string
      title         = string
      email_address = string
      phone_number  = optional(string)
    }))
  })
}

variable "tags" {
  description = "A map of tags to add to the created accounts"
  type        = map(string)
  default     = {}
}
