variable "client" {
  type        = string
  description = "The name of client (eg. myclient)"
}

variable "project" {
  type        = string
  description = "The name of project (eg. myproject)"
}

variable "role_arn" {
  type        = string
  description = "The arn of role for function"
}

variable "name" {
  type        = string
  description = "The name of function"
}

variable "memory" {
  type        = number
  description = "The max ammount of memory to allocate"
}

variable "timeout" {
  type        = number
  description = "The max execution time of function"
}

variable "python_version" {
  type        = string
  description = "The version of python for function"
}

variable "package" {
  type        = string
  description = "The path of package for function"
}

variable "handler" {
  type        = string
  description = "The file and function name to invoke the function"
}
