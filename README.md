# API Gateway + Lambda proxy resource

# AWS Services
- S3 bucket (TF remote state)
- API Gateway
- Lambda
- Route53
- CloudWatch


# How to point to another project
1. Update the `.env` 
  AWS_BUCKET_NAME
2. Update terraform `pipeline/terraform/variables.tf` 
  replace `some_awesome_site_com` & `some-awesome-site` and the rest should work



# TODO
[x] Terraform build prod
[x] Terraform build staging
[x] Add CloudWatchlogging
[] github actions


