
# Cloudwatch Logs
resource "aws_cloudwatch_log_group" "function_logs" {
  name              = "/aws/lambda/${local.app_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name = "${local.app_name}_lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = file("iam/lambda-cloudwatch-policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}