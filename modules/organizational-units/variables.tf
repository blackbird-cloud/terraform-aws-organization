variable "organization_units" {
  description = "List of organizational units to create"
  type = map(object(
    {
      parent_id = string
      tags      = optional(map(string))
    }
  ))
}
