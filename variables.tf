variable "account_id" {
  type        = string
  description = "Cloudflare Account ID"
}
variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "zone_name" {
  type        = string
  description = "Cloudflare Zone Name"
}

variable "dmarc_rua" {
  type        = list(string)
  description = "Email addresses for DMARC Aggregate reports (excluding `mailto:`)"

  validation {
    condition     = length(var.dmarc_rua) != 0
    error_message = "Must contain at least one email address."
  }

  validation {
    condition     = can([for email in var.dmarc_rua : regex("@", email)])
    error_message = "Must be a valid email address."
  }
}

variable "dmarc_ruf" {
  type        = list(string)
  description = "Email addresses for DMARC Failure (or Forensic) reports (excluding `mailto:`)"

  validation {
    condition     = length(var.dmarc_ruf) != 0
    error_message = "Must contain at least one email address."
  }

  validation {
    condition     = can([for email in var.dmarc_ruf : regex("@", email)])
    error_message = "Must be a valid email address."
  }
}

variable "spf_terms" {
  type        = list(string)
  description = "Additional SPF terms to include, `include:spf.messagingengine.com -all` are already provided"
  default     = []

  validation {
    condition     = can([for term in var.spf_terms : regex("^(\\+|-|\\?|~)?(all|include|a|mx|ip4|ip6|exists)", term)])
    error_message = "SPF term must start with a valid qualifier (optional) or mechanism."
  }
}

variable "mta_sts_mode" {
  type        = string
  default     = "testing"
  description = "Sending MTA policy application, https://tools.ietf.org/html/rfc8461#section-5"

  validation {
    condition     = contains(["enforce", "testing", "none"], var.mta_sts_mode)
    error_message = "Only `enforce` `testing` or `none` is valid."
  }
}

variable "mta_sts_mx" {
  type        = list(string)
  default     = []
  description = "List of additional permitted MX hosts for the MTA STS policy. This does not create the resources for."
}

variable "mta_sts_max_age" {
  type        = number
  default     = 604800 # 1 week
  description = "Maximum lifetime of the MTA STS policy in seconds, up to 31557600, defaults to 604800 (1 week)"

  validation {
    condition     = var.mta_sts_max_age >= 0
    error_message = "Policy validity time must be positive."
  }

  validation {
    condition     = var.mta_sts_max_age <= 31557600
    error_message = "Policy validity time must be less than 1 year (31557600 seconds)."
  }
}

variable "tlsrpt_rua" {
  type        = list(string)
  description = "Locations to which MTA STS aggregate reports about policy violations should be sent, either `mailto:` or `https:` schema."

  validation {
    condition     = length(var.tlsrpt_rua) != 0
    error_message = "At least one `mailto:` or `https:` endpoint provided."
  }

  validation {
    condition     = can([for loc in var.tlsrpt_rua : regex("^(mailto|https):", loc)])
    error_message = "Locations must start with either the `mailto: or `https` schema."
  }
}
