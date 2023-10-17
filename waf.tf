###======================== CTF WAF ====================== ###

resource "aws_wafv2_web_acl" "waf" {
  name        = "ctf-waf"
  description = "AWS managed rule groups."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ctf-waf"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf" {
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
  resource_arn            = aws_wafv2_web_acl.waf.arn
}

resource "aws_wafv2_web_acl_association" "waf_owaspjs" {
  resource_arn = aws_lb.owaspjs.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}

resource "aws_wafv2_web_acl_association" "waf_cftd" {
  resource_arn = aws_lb.cftd.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}
