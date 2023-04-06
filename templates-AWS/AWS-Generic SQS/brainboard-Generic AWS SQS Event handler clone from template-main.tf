# Brainboard auto-generated file.

resource "aws_lambda_function" "event_handler" {
  tags          = merge(var.tags, {})
  role          = aws_iam_role.handler_role.arn
  function_name = "event_handler"

  dead_letter_config {
    target_arn = aws_sqs_queue.sqs_dlq.arn
  }
}

resource "aws_iam_role" "handler_role" {
  tags               = merge(var.tags, {})
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_sqs_queue" "sqs_intake_queue" {
  tags = merge(var.tags, {})
}

resource "aws_lambda_event_source_mapping" "lambda_event_source_mapping_5" {
  function_name    = aws_lambda_function.event_handler.arn
  event_source_arn = aws_sqs_queue.sqs_intake_queue.arn
}

resource "aws_sqs_queue" "sqs_dlq" {
  tags                      = merge(var.tags, {})
  message_retention_seconds = 1209600
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_dlq_alarm" {
  unit                = "Count"
  tags                = merge(var.tags, {})
  statistic           = "Maximum"
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  comparison_operator = "GreaterThanThreshold"
  alarm_name          = "DLQ Alarm"
  alarm_description   = "Dead letter queue is not empty"

  dimensions = {
    QueueName = "sqs_dlq"
  }
}

