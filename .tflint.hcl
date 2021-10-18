config {
  module = true
}

plugin "aws" {
  enabled    = true
  deep_check = false
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

#TODO: Enable once context.tf is moved to Tyler controlled repo
# rule "terraform_comment_syntax" {
#   enabled = true
# }

#TODO: Enable once context.tf is moved to Tyler controlled repo
# rule "terraform_standard_module_structure" {
#   enabled = true
# }

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}