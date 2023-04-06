# Brainboard auto-generated file.

resource "aws_cognito_user_pool" "GoZeit-cognito" {
  name = "GoZeit-cognito"

  tags = {
    env = "development"
  }
}

resource "aws_ses_email_identity" "aws_ses_email_identity-4b588fbd" {
}

resource "aws_route53_zone" "GoZeit-route53-zone" {
  name = "GoZeit-route53-zone"

  tags = {
    env = "development"
  }
}

resource "aws_apigatewayv2_api" "GoZeit-api-gw" {
  name = "GoZeit-api-gw"

  tags = {
    env = "development"
  }
}

resource "aws_lambda_function" "aws_lambda_function-1e320c3e" {

  tags = {
    env = "development"
  }
}

resource "aws_s3_bucket" "aws_s3_bucket-ac362a72" {

  tags = {
    env = "test"
  }
}

resource "aws_dynamodb_global_table" "aws_dynamodb_global_table-cc2f0b8f" {
}

resource "aws_lambda_function" "aws_lambda_function-e94ef1e8" {

  tags = {
    env = "development"
  }
}

resource "aws_cloudwatch_dashboard" "aws_cloudwatch_dashboard-646027d9" {
}

resource "aws_lambda_function" "aws_lambda_function-864c7820" {

  tags = {
    env = "development"
  }
}

resource "aws_cloudfront_distribution" "GoZeit-cf" {

  tags = {
    env = "development"
  }
}

resource "aws_s3_bucket" "aws_s3_bucket-9513ce4f" {

  tags = {
    env = "test"
  }
}

resource "aws_lambda_function" "aws_lambda_function-a66c58f9" {

  tags = {
    env = "development"
  }
}

