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
