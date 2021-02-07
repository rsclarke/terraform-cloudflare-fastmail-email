# terraform-cloudflare-fastmail-email

MX, SPF, DKIM and DMARC records with MTA-STS policy (via [terraform-cloudflare-mta-sts](https://github.com/rsclarke/terraform-cloudflare-mta-sts)) for email hosted by Fastmail.

This creates `cloudflare_record` resources for MX, SPF, DKIM, DMARC and MTA-STS of the given `zone_id` suitable for [fastmail.com](https://fastmail.com).  A Cloudflare Worker as part of the [terraform-cloudflare-mta-sts](https://github.com/rsclarke/terraform-cloudflare-mta-sts) dependency serves the MTA-STS policy.

The SPF policy includes Fastmail by default and rejects all others (`-all`), additional terms can be specified using the `spf_terms` variable.  

The DMARC policy is set to reject and you must provide an email address for DMARC Aggregate and Failure reports through the `dmarc_rua` and `dmarc_ruf` variables respectively.  Similarly, a TLS aggregate reporting location (`mailto:` or `https:`) must be specified in the `tlsrpt_rua` variable.

## Usage

```terraform

resource "cloudflare_zone" "example_com" {
  zone = "example.com"
}

module {
  source = "rsclarke/fastmail-email/cloudflare"

  zone_id   = cloudflare_zone.example_com.id
  zone_name = cloudflare_zone.example_com.name

  dmarc_rua = ["dmarc_rua@example.net"]
  dmarc_ruf = ["dmarc_ruf@example.net", "dmarc_ruf@example.org"]
  spf_terms = ["-ip4:192.0.2.0/24", "+ip6:2001:DB8::/32"]

  mta_sts_mode    = "enforce"
  mta_sts_mx      = ["mx.example.net"]
  mta_sts_max_age = 604800
  tlsrpt_rua      = ["mailto:tls_report@example.org", "https://example.org/mta-sts/report"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | `~> 0.14.0` |
| cloudflare | `>= 2.0` |

## Providers

| Name | Version |
|------|---------|
| cloudflare | `>= 2.0` |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| zone_id | Cloudflare Zone ID | `string` | yes |
| zone_name | Cloudflare Zone Name | `string` | yes |
| dmarc_rua | Email addresses for DMARC Aggregate reports (excluding `mailto:`), at least one and contains the `@` symbol. | `list(string)` | yes |
| dmarc_rua | Email addresses for DMARC Failure (or Forensic) reports (excluding `mailto:`), at least one and contains the `@` symbol. | `list(string)` | yes |
| spf_terms | Additional SPF terms to include, `include:spf.messagingengine.com -all` are already provided. | `list(string)` | no |
| mta_sts_mode | Sending MTA policy application, [rfc8461#section-5](https://tools.ietf.org/html/rfc8461#section-5).  Default `testing` | `string` | no |
| mta_sts_mx | List of additional permitted MX hosts for the MTA STS policy. This does not create the resources for. | `list(string)` | no |
| mta_sts_max_age | Maximum lifetime of the MTA STS policy in seconds, up to 31557600, defaults to 604800 (1 week) | `number` | no |
| tlsrpt_rua | Locations to which MTA STS aggregate reports about policy violations should be sent, either `mailto:` or `https:` schema. | `list(string)` | yes |

## Outputs

This module does not expose any ouputs.
