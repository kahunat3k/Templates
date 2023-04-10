# Brainboard auto-generated file.

resource "aws_budgets_budget" "ec2" {
  time_unit         = "MONTHLY"
  time_period_start = "2021-11-01_00:00"
  name              = "ec2"
  limit_unit        = "USD"
  limit_amount      = var.ec2_amount_limitation
  budget_type       = "COST"

  cost_filter {
    name = "Service"
    values = [
      "Amazon Elastic Compute Cloud - Compute",
    ]
  }

  cost_types {
    include_upfront      = true
    include_subscription = true
    include_discount     = true
    include_credit       = true
  }

  notification {
    threshold_type      = "PERCENTAGE"
    threshold           = var.ec2_threshold
    notification_type   = "FORECASTED"
    comparison_operator = "GREATER_THAN"
    subscriber_email_addresses = [
      var.email,
    ]
  }
}

resource "aws_budgets_budget" "monthly" {
  time_unit         = "MONTHLY"
  time_period_start = "2021-11-01_00:00"
  name              = "monthly"
  limit_unit        = "USD"
  limit_amount      = var.amount_limitation
  budget_type       = "COST"

  cost_types {
    include_upfront      = true
    include_subscription = true
    include_discount     = true
    include_credit       = true
  }

  notification {
    threshold_type      = "PERCENTAGE"
    threshold           = var.threshold
    notification_type   = "ACTUAL"
    comparison_operator = "GREATER_THAN"
    subscriber_email_addresses = [
      var.email,
    ]
  }
}

resource "aws_budgets_budget" "ri_utilization" {
  time_unit    = "MONTHLY"
  name         = "ri_utilization"
  limit_unit   = "PERCENTAGE"
  limit_amount = "100.0"
  budget_type  = "RI_UTILIZATION"

  cost_types {
    use_blended                = false
    use_amortized              = false
    include_upfront            = false
    include_tax                = false
    include_support            = false
    include_subscription       = true
    include_refund             = false
    include_recurring          = false
    include_other_subscription = false
    include_discount           = false
    include_credit             = false
  }
}

resource "aws_budgets_budget" "s3" {
  time_unit    = "MONTHLY"
  name         = "s3"
  limit_unit   = "GB"
  limit_amount = var.s3_amount
  budget_type  = "USAGE"

  cost_types {
    include_subscription = true
    include_refund       = true
    include_discount     = true
    include_credit       = true
  }
}

