variable "aws_region" {
  description = "The region to deploy into (defaults to 'ca-central-1' for legal reasons)"
  type        = string

  default = "ca-central-1"
}

variable "aws_availability_zone_a" {
  description = "The availability zone to deploy into (defaults to 'ca-central-1a' for legal reasons)"
  type        = string

  default = "ca-central-1a"
}

variable "aws_availability_zone_b" {
  description = "The availability zone to deploy into (defaults to 'ca-central-1b' for legal reasons)"
  type        = string

  default = "ca-central-1b"
}

variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the CTF VPC"
  type        = string

  default = "192.168.42.0/24"
}

variable "subnet_a_public_cidr_block" {
  description = "The IPv4 CIDR block for the public subnet A"
  type        = string

  default = "192.168.42.0/27"
}

variable "subnet_b_public_cidr_block" {
  description = "The IPv4 CIDR block for the public subnet B"
  type        = string

  default = "192.168.42.32/27"
}

variable "subnet_natgw_cidr_block" {
  description = "The IPv4 CIDR block for the NAT Gateway subnet"
  type        = string

  default = "192.168.42.64/27"
}

variable "subnet_owaspjs_cidr_block" {
  description = "The IPv4 CIDR block for the OWASP Juice Shop subnet"
  type        = string

  default = "192.168.42.96/27"
}

variable "subnet_cftd_cidr_block" {
  description = "The IPv4 CIDR block for the CFTd subnet"
  type        = string

  default = "192.168.42.128/27"
}

variable "subnet_a_rds_cidr_block" {
  description = "The IPv4 CIDR block for the RDS subnet A"
  type        = string

  default = "192.168.42.160/27"
}

variable "subnet_b_rds_cidr_block" {
  description = "The IPv4 CIDR block for the RDS subnet B"
  type        = string

  default = "192.168.42.208/28"
}

variable "instance_type" {
  description = "The instance type to use for the CTFd and OWASP Juice Shop EC2 instances"
  type        = string

  default = "t2.micro"
}

variable "db_password" {
  description = "RDS user password"
  type        = string
  sensitive   = true
}

# AWS Managed Rules rule groups list
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html

variable "managed_rules" {
  description = "List of AWS Managed WAF rules to apply to Web ACLs."

  type = list(object({
    name            = string
    priority        = number
    override_action = string
  }))

  validation {
    condition = alltrue([for rule in var.managed_rules : contains([
      "AWSManagedRulesCommonRuleSet",
      "AWSManagedRulesAdminProtectionRuleSet",
      "AWSManagedRulesKnownBadInputsRuleSet",
      "AWSManagedRulesSQLiRuleSet",
      "AWSManagedRulesLinuxRuleSet",
      "AWSManagedRulesUnixRuleSet",
      "AWSManagedRulesAmazonIpReputationList",
      "AWSManagedRulesAnonymousIpList",
      "AWSManagedRulesBotControlRuleSet",
    ], rule.name)])
    error_message = "Unsupported AWS Managed Rule provided."
  }

  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#override-action
  validation {
    condition     = alltrue([for rule in var.managed_rules : contains(["none", "count"], rule.override_action)])
    error_message = "Unsupported override action, valid inputs are 'none' and 'count'."
  }

  default = [
    {
      name            = "AWSManagedRulesAmazonIpReputationList",
      priority        = 10
      override_action = "count"
    },
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 20
      override_action = "count"
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 30
      override_action = "count"
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet",
      priority        = 40
      override_action = "count"
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 50
      override_action = "count"
    },
    {
      name            = "AWSManagedRulesUnixRuleSet",
      priority        = 60
      override_action = "count"
    },
    {
      name            = "AWSManagedRulesBotControlRuleSet",
      priority        = 70
      override_action = "count"
    },
  ]
}
