data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
#
# Based on AWS documentation: Encrypt log data in CloudWatch Logs using AWS Key Management Service
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html
#
data "aws_iam_policy_document" "cloudwatch_waf_kms" {
  # checkov:skip=CKV_AWS_109: Allow `*` resources
  # checkov:skip=CKV_AWS_111: Allow `kms:*` actions
  # checkov:skip=CKV_AWS_356: Allow `kms:*` actions
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }

    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    resources = ["*"]

    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"

      values = ["arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:aws-waf-logs-*"]
    }
  }
}

resource "aws_kms_key" "cloudwatch_waf" {
  description         = "aws-waf-logs-ctf-key"
  key_usage           = "ENCRYPT_DECRYPT"
  multi_region        = true
  enable_key_rotation = true

  policy = data.aws_iam_policy_document.cloudwatch_waf_kms.json
}

resource "aws_kms_alias" "cloudwatch_waf" {
  name          = "alias/aws-waf-logs-ctf-key"
  target_key_id = aws_kms_key.cloudwatch_waf.key_id
}

resource "aws_cloudwatch_log_group" "waf" {
  # checkov:skip=CKV_AWS_338: Ensure CloudWatch log groups retains logs for at least 1 year

  name              = "aws-waf-logs-ctf"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.cloudwatch_waf.arn
}

###=============== CloudWatch Log Insights - Queries   =============== ###

resource "aws_cloudwatch_query_definition" "tail" {
  name = "WAF/Tail View (ctf)"

  log_group_names = [aws_cloudwatch_log_group.waf.name]

  query_string = <<EOF
fields @timestamp as Timestamp,
  action as Action,
  terminatingRuleId as Rule,
  httpRequest.clientIp as Request_IP,
  httpRequest.country as Request_Country,
  httpRequest.httpMethod as Request_Method,
  httpRequest.uri as URI
| sort @timestamp desc
| limit 100
EOF
}

resource "aws_cloudwatch_query_definition" "filter_by_clientip" {
  name = "WAF/Filter by Client IP (ctf)"

  log_group_names = [aws_cloudwatch_log_group.waf.name]

  query_string = <<EOF
fields @timestamp as Timestamp,
  action as Action,
  httpRequest.country as Request_Country,
  httpRequest.httpMethod as Request_Method,
  httpRequest.uri as URI,
  labels.0.name	as WAF_Rule,
  terminatingRuleId as WAF_RuleID
| sort @timestamp desc
| filter httpRequest.clientIp LIKE "8.8.8.8"
EOF
}

resource "aws_cloudwatch_query_definition" "filter_by_rule" {
  name = "WAF/Filter by Rule (ctf)"

  log_group_names = [aws_cloudwatch_log_group.waf.name]

  query_string = <<EOF
fields @timestamp as Timestamp,
  action as Action,
  terminatingRuleId as Rule,
  httpRequest.clientIp as Request_IP,
  httpRequest.country as Request_Country,
  httpRequest.httpMethod as Request_Method,
  httpRequest.uri as URI
| sort @timestamp desc
| filter terminatingRuleId in ["AWSManagedRulesAmazonIpReputationList", "AWSManagedRulesCommonRuleSet", "AWSManagedRulesKnownBadInputsRuleSet", "AWSManagedRulesSQLiRuleSet", "AWSManagedRulesLinuxRuleSet"]
or nonTerminatingMatchingRules.0.ruleId in ["AWSManagedRulesAmazonIpReputationList", "AWSManagedRulesCommonRuleSet", "AWSManagedRulesKnownBadInputsRuleSet", "AWSManagedRulesSQLiRuleSet", "AWSManagedRulesLinuxRuleSet"]
EOF
}
