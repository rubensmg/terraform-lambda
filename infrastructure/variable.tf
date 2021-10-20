variable "client" {
  type        = string
  description = "The name of client (eg. myclient)"
}

variable "project" {
  type        = string
  description = "The name of project (eg. myproject)"
}


variable "functions" {
  type = list(object({
    name           = string
    handler        = string
    path           = string
    memory         = number
    timeout        = number
    python_version = string
  }))
  description = "Array of functions associated with this project"
}
