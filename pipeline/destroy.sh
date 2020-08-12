. .env

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
NOCOLOR="\033[0m"

# ENV
ENVIRONMENT=${1:-prod}

# #--Delete the contents of the s3 bucket --------
# if [ $ENVIRONMENT == "prod" ] ; then
#   echo "${GREEN}[Deleting]${NOCOLOR} s3 bucket ${AWS_BUCKET_NAME}"
#   aws s3 rm s3://${AWS_BUCKET_NAME}/  --recursive
# else
#   echo "${GREEN}[Deleting]${NOCOLOR} s3 bucket staging.${AWS_BUCKET_NAME}"
#   aws s3 rm s3://staging.${AWS_BUCKET_NAME}/  --recursive
# fi


#--Destroy services with terraform ------------
pushd pipeline/terraform
terraform workspace select ${ENVIRONMENT}
terraform destroy
popd