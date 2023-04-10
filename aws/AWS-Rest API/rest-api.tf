# Brainboard auto-generated file.

resource "aws_vpc" "restAPI-vpc" {
  enable_dns_support = true
  enable_classiclink = true
  cidr_block         = "10.0.0.0/16"

  tags = {
    env      = "development"
    archUUID = "1d36075c-54dd-4bf7-a797-c19d1ff008a3"
  }
}

resource "aws_lambda_function" "restAPI-lambda" {
  runtime       = "nodejs12.x"
  role          = var.role
  handler       = var.handler
  function_name = "restAPI-function"

  tags = {
    env      = "development"
    archUUID = "1d36075c-54dd-4bf7-a797-c19d1ff008a3"
  }
}

resource "aws_docdb_cluster" "restAPI-documentdb" {

  tags = {
    env      = "development"
    archUUID = "1d36075c-54dd-4bf7-a797-c19d1ff008a3"
  }
}

resource "aws_secretsmanager_secret" "restAPI-db-creds" {

  tags = {
    env      = "development"
    archUUID = "1d36075c-54dd-4bf7-a797-c19d1ff008a3"
  }
}

resource "aws_lambda_function" "restAPI-lambda-ext" {
  runtime       = "nodejs12.x"
  role          = var.role-ext
  handler       = var.handler-ext
  function_name = "restAPI-function-ext"

  tags = {
    env      = "development"
    archUUID = "1d36075c-54dd-4bf7-a797-c19d1ff008a3"
  }
}

resource "aws_subnet" "restAPI-subnet" {
  vpc_id     = aws_vpc.restAPI-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    env      = "development"
    archUUID = "1d36075c-54dd-4bf7-a797-c19d1ff008a3"
  }
}

resource "aws_apigatewayv2_api" "restAPI-gw" {
  protocol_type = "HTTP"
  name          = "restAPI--gw"

  tags = {
    env      = "development"
    archUUID = "1d36075c-54dd-4bf7-a797-c19d1ff008a3"
  }
}

