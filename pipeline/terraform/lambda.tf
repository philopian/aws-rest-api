locals {
  lambda_zipped = "outputs/lambda_function_payload.zip"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${local.app_name}_service_role"
  assume_role_policy = file("iam/lambda-assumed-policy.json")
}

resource "aws_lambda_function" "api_proxy" {
  filename      = local.lambda_zipped
  function_name = local.app_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256(local.lambda_zipped)
  runtime = "nodejs12.x"

  environment {
    variables = {
      ENV = terraform.workspace
    }
  }

  tags = local.default_tags

  depends_on    = [aws_iam_role_policy_attachment.lambda_logs, aws_cloudwatch_log_group.function_logs]
}