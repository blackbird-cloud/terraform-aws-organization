variable "organizations_policies" {
  description = "A map of policies to attach to the organization"
  type = map(object({
    content      = string
    ous          = list(string)
    description  = optional(string)
    skip_destroy = optional(bool)
    type         = optional(string)
  }))
}

variable "tags" {
  description = "A map of tags to add to the resources"
  type        = map(string)
}
