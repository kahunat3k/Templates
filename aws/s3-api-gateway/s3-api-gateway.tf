# Brainboard auto-generated file.

resource "aws_iam_policy" "s3_policy" {
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
  description = "Policy for allowing all S3 Actions"
}

resource "aws_iam_role" "s3_api_gateyway_role" {
  name               = "s3_api_gateyway_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    env      = "Staging"
    archUUID = "682c2db8-5d36-4383-b248-cb2142e2b6fb"
  }
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.s3_api_gateyway_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_api_gateway_rest_api" "s3_gtw" {
  name        = "S3GTW"
  description = "API for S3 Integration"
}

resource "aws_api_gateway_resource" "folder" {
  rest_api_id = aws_api_gateway_rest_api.s3_gtw.id
  path_part   = { folder }
  parent_id   = aws_api_gateway_rest_api.s3_gtw.root_resource_id
}

resource "aws_api_gateway_resource" "item" {
  rest_api_id = aws_api_gateway_rest_api.s3_gtw.id
  path_part   = { item }
  parent_id   = aws_api_gateway_resource.folder.id
}

resource "aws_api_gateway_method" "GetBuckets" {
  rest_api_id   = aws_api_gateway_rest_api.s3_gtw.id
  resource_id   = aws_api_gateway_rest_api.s3_gtw.root_resource_id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "S3Integration" {
  uri         = "arn:aws:apigateway:${var.region}:s3:path//"
  type        = "AWS"
  rest_api_id = aws_api_gateway_rest_api.s3_gtw.id
  resource_id = aws_api_gateway_rest_api.s3_gtw.root_resource_id
  http_method = "GET"
  credentials = aws_iam_role.s3_api_gateyway_role.arn
}

resource "aws_api_gateway_method_response" "Status200" {
  status_code = "200"
  rest_api_id = aws_api_gateway_rest_api.s3_gtw.id
  resource_id = aws_api_gateway_rest_api.s3_gtw.root_resource_id
  http_method = aws_api_gateway_method.GetBuckets.http_method
}

resource "aws_api_gateway_method_response" "Status500" {
  status_code = "500"
  rest_api_id = aws_api_gateway_rest_api.s3_gtw.id
  resource_id = aws_api_gateway_rest_api.s3_gtw.root_resource_id
  http_method = aws_api_gateway_method.GetBuckets.http_method

  depends_on = [
    aws_api_gateway_integration.S3Integration,
  ]
}

resource "aws_api_gateway_method_response" "Status400" {
  status_code = "400"
  rest_api_id = aws_api_gateway_rest_api.s3_gtw.id
  resource_id = aws_api_gateway_rest_api.s3_gtw.root_resource_id
  http_method = aws_api_gateway_method.GetBuckets.http_method

  depends_on = [
    aws_api_gateway_integration.S3Integration,
  ]
}

resource "aws_api_gateway_integration_response" "IntegrationResponse500" {
  status_code       = aws_api_gateway_method_response.Status500.status_code
  selection_pattern = "5\\d{2}"
  rest_api_id       = aws_api_gateway_rest_api.s3_gtw.id
  resource_id       = aws_api_gateway_rest_api.s3_gtw.root_resource_id
  http_method       = aws_api_gateway_method.GetBuckets.http_method

  depends_on = [
    aws_api_gateway_integration.S3Integration,
  ]
}

resource "aws_api_gateway_integration_response" "IntegrationResponse400" {
  status_code       = aws_api_gateway_method_response.Status400.status_code
  selection_pattern = "4\\d{2}"
  rest_api_id       = aws_api_gateway_rest_api.s3_gtw.id
  resource_id       = aws_api_gateway_rest_api.s3_gtw.root_resource_id
  http_method       = aws_api_gateway_method.GetBuckets.http_method

  depends_on = [
    aws_api_gateway_integration.S3Integration,
  ]
}

resource "aws_api_gateway_integration_response" "IntegrationResponse200" {
  status_code = aws_api_gateway_method_response.Status200.status_code
  rest_api_id = aws_api_gateway_rest_api.s3_gtw.id
  resource_id = aws_api_gateway_rest_api.s3_gtw.root_resource_id
  http_method = aws_api_gateway_method.GetBuckets.http_method

  depends_on = [
    aws_api_gateway_integration.S3Integration,
  ]
}

resource "aws_api_gateway_deployment" "S3APIDeployment" {
  stage_name  = "BrainboardS3"
  rest_api_id = aws_api_gateway_rest_api.s3_gtw.id

  depends_on = [
    aws_api_gateway_integration.S3Integration,
  ]
}

