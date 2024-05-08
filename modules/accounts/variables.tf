variable "accounts" {
  description = "List of AWS accounts to create"
  type = map(object({
    email                            = string
    close_on_deletion                = optional(bool)
    iam_user_access_to_billing       = optional(bool)
    delegated_administrator_services = list(string)
    tags                             = optional(map(string))
    parent_id                        = optional(string)
  }))
}

variable "contacts" {
  description = "Primary and alternate contacts for the accounts"
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
    operations_contact = object({
      name          = string
      title         = string
      email_address = string
      phone_number  = optional(string)
    })
    billing_contact = object({
      name          = string
      title         = string
      email_address = string
      phone_number  = optional(string)
    })
    security_contact = object({
      name          = string
      title         = string
      email_address = string
      phone_number  = optional(string)
    })
  })
  default = {
    primary_contact = {
      address_line_1 = "henk"
      city           = "Amsterdam"
      country_code   = "NL"
      full_name      = "Henk"
      phone_number   = "+31612345678"
      postal_code    = "1234AB"
    }
    operations_contact = {
      name          = "Henk"
      title         = "Operations"
      email_address = "henk@henk.com"
      phone_number  = "+31612345678"
    }
    billing_contact = {
      name          = "Henk"
      title         = "Billing"
      email_address = "henk@henk.com"
      phone_number  = "+31612345678"
    }
    security_contact = {
      name          = "Henk"
      title         = "Security"
      email_address = "henk@henk.com"
      phone_number  = "+31612345678"
    }
  }
}