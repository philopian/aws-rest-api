########################################################################################
# Terraform state file --> AmazonS3>terraform-state-files-etc>env:>(staging|prod)
terraform {
  backend "s3" {
    key    = "api_some_awesome_site_com.tfstate" # <== Update this filename (<SITE_NAME>tfstate)
    bucket = "terraform-state-files-etc"
    region = "us-west-2"
  }
}

# Define your website here and the rest will follow
variable "app_namespace" {
  default = "api_some_awesome_site_com" # <== Update base domain name
}

# Define your website here and the rest will follow
variable "web_url" {
  default = "some-awesome-site.com" # <== Update base domain name
}

variable "hosted_zone_name" {
  default = "some-awesome-site.com"
}

# Route 53 is created when we bought the domain in AWS
variable "route53_zone_id" {
  default = "Z3OKBH3A8B11JS" # <== Update the hosted zone id with the one in Route53
}

# Because we manually created the ACM Cert it's
variable "acm_cert" {
  default = "arn:aws:acm:us-east-1:305296289371:certificate/349f7e82-c365-454c-b431-111b54648356"
}
########################################################################################
