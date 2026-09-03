variable "organization_units" {
  description = "Map of organizational units to create. The map key is used as the OU name unless `name` is set explicitly."
  type = map(object({
    parent_id = string
    name      = optional(string)
    tags      = optional(map(string), {})
  }))
}
