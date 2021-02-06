# terraform-cloudflare-fastmail-email

MX, SPF, DKIM and DMARC records for email hosted by Fastmail.

This creates `cloudflare_record` resources for MX, SPF, DKIM and DMARC of the given `zone_id` suitable for [fastmail.com](https://fastmail.com).

The SPF policy includes Fastmail by default and rejects all others (`-all`).  The DMARC policies is set to reject and you must provide an email address for DMARC Aggregate and Failure reports through the `dmarc_rua` and `dmarc_ruf` variables respectively.

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

## Outputs

This module does not expose any ouputs.
