# Create the actual resource
resource "aws_api_gateway_rest_api" "apig" {
  name        = local.app_name
  description = "Terraform Serverless Application Example"
}

# Single proxy resource (resource/method)
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.apig.id
  parent_id   = aws_api_gateway_rest_api.apig.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apig.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Specify where request to this method should send to the lambda function
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.apig.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_proxy.invoke_arn
}


# # Root Resource
# resource "aws_api_gateway_method" "proxy_root" {
#   rest_api_id   = aws_api_gateway_rest_api.apig.id
#   resource_id   = aws_api_gateway_rest_api.apig.root_resource_id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda_root" {
#   rest_api_id = aws_api_gateway_rest_api.apig.id
#   resource_id = aws_api_gateway_method.proxy_root.resource_id
#   http_method = aws_api_gateway_method.proxy_root.http_method

#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.api_proxy.invoke_arn
# }

# Deployment
resource "aws_api_gateway_deployment" "apig_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    # aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.apig.id
  stage_name  = local.api_version
}

# Allowing API Gateway to Access Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_proxy.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.apig.execution_arn}/*/*"
}



########################################################################################################
# https://stackoverflow.com/questions/55031167/terraform-with-api-gateway-route53-and-ssl-certification-interdependency-probl
data "aws_route53_zone" "base" {
  name         = "${var.hosted_zone_name}."
  private_zone = false
}

# The domain name to use with api-gateway
resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name     = local.api_domain_name
  # certificate_arn = data.aws_acm_certificate.cert.arn
  certificate_arn = var.acm_cert
}

# The record for 
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.base.zone_id
  name    = aws_api_gateway_domain_name.api_domain.domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.api_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.api_domain.cloudfront_zone_id
    evaluate_target_health = true
  }
}

# Connects a custom domain name registered via aws_api_gateway_domain_name with a deployed API so that its methods can be called via the custom domain name.
resource "aws_api_gateway_base_path_mapping" "apig" {
  depends_on = [
    aws_api_gateway_deployment.apig_deployment,
  ]

  api_id      = aws_api_gateway_rest_api.apig.id
  domain_name = aws_api_gateway_domain_name.api_domain.domain_name
  stage_name  = aws_api_gateway_deployment.apig_deployment.stage_name
  base_path   = ""

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_authorizer" "oauthorizer" {
  name                             = "oauthorizer"
  rest_api_id                      = aws_api_gateway_rest_api.apig.id
  authorizer_uri                   = aws_lambda_function.api_proxy.invoke_arn
  authorizer_result_ttl_in_seconds = 180
}
