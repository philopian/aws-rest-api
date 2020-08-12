
# https://stgapi.some-awesome-site.com/v1/{proxy+}
# https://api.some-awesome-site.com/v1/{proxy+}

locals {
  app_name      = "${var.app_namespace}_${terraform.workspace}"
  api_version   = "v1"

  # Multi account mapping. Get the account from the tf workspace, default is staging 
  account                = lookup(local.account_values["accounts"], terraform.workspace, "staging")

  # Account based values
  api_domain_name_prefix   = local.account_values[local.account]["domain_prefix"]
  base_domain_name         = var.web_url
  api_domain_name          = "${local.api_domain_name_prefix}${local.base_domain_name}"

  account_values = {
    accounts = {
      staging  = "staging"
      prod = "prod"
    }
    staging = {
      domain_prefix   = "stgapi."
      env_tag         = "Staging"
    }
    prod = {
      domain_prefix   = "api."
      env_tag         = "Prod"
    }
  }

  default_tags = {
    Environment = local.account_values[local.account]["env_tag"]
    BuiltWith = "Terraform"
  }
}
