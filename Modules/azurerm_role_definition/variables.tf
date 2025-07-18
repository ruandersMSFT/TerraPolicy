variable "assignable_scopes" {
  description = "(Required) The Assignable Scopes of the Role Definition."
  type        = list(string)
}

variable "description" {
  description = "(Required) The Description of the Role Definition."
  type        = string
}

variable "name" {
  description = "(Required) The Name of the Role Defintion."
  type        = string
}

variable "permissions" {
  description = "A list of permission blocks to assign to the role definition."
  type = list(object({
    actions     = list(string)
    not_actions = list(string)
  }))
  default = []
}

variable "role_definition_id" {
  description = "(Optional) A unique UUID/GUID which identifies this role - one will be generated if not specified. Changing this forces a new resource to be created."
  type        = string
  default    = null
}

variable "scope" {
  description = "(Required) The scope at which the Role Definition applies to."
  type        = string
}


