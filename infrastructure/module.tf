module "role" {
  source  = "./role"
  client  = var.client
  project = var.project
}

module "packages" {
  for_each = { for function in var.functions : function.name => function }
  source   = "./package"
  path     = each.value.path
}

module "functions" {
  for_each       = { for function in var.functions : function.name => function }
  source         = "./function"
  client         = var.client
  project        = var.project
  name           = each.key
  handler        = each.value.handler
  python_version = each.value.python_version
  memory         = each.value.memory
  timeout        = each.value.timeout
  role_arn       = module.role.arn
  package        = module.packages[each.key].output
  depends_on = [
    module.role,
    module.packages
  ]
}

module "logs" {
  for_each = { for function in var.functions : function.name => function }
  source   = "./log"
  project  = var.project
  client   = var.client
  name     = module.functions[each.key].name
  depends_on = [
    module.functions
  ]
}

output "functions" {
  value = [for function in module.functions : function.name]
}
