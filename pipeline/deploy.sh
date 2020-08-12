. .env

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
NOCOLOR="\033[0m"


# Zip lambda function source code
echo "${GREEN}[Zipping]${NOCOLOR} Local Lambda function"
pushd src
zip -r ../pipeline/terraform/outputs/lambda_function_payload.zip *
popd

#--Terraform Stuff -------------------------------
ENVIRONMENT=${1:-prod}

echo "${GREEN}[TF ENV]${NOCOLOR} ${ENVIRONMENT}"
pushd pipeline/terraform
terraform init
if ! terraform workspace select ${ENVIRONMENT}; then
    terraform workspace new ${ENVIRONMENT}
fi
echo "${GREEN}[Building]${NOCOLOR} Infrastructure"
# terraform plan
terraform apply -auto-approve
# bucket_name=$(terraform output bucket_name)
popd
