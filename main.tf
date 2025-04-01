resource "cloudflare_dns_record" "mx1" {
  zone_id  = var.zone_id
  name     = "@"
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  priority = 10
  ttl      = 1
}

resource "cloudflare_dns_record" "mx2" {
  zone_id  = var.zone_id
  name     = "@"
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  priority = 20
  ttl      = 1
}

resource "cloudflare_dns_record" "dkim1" {
  zone_id = var.zone_id
  name    = "fm1._domainkey"
  type    = "CNAME"
  content = "fm1.${var.zone_name}.dkim.fmhosted.com"
  ttl     = 1
}

resource "cloudflare_dns_record" "dkim2" {
  zone_id = var.zone_id
  name    = "fm2._domainkey"
  type    = "CNAME"
  content = "fm2.${var.zone_name}.dkim.fmhosted.com"
  ttl     = 1
}

resource "cloudflare_dns_record" "dkim3" {
  zone_id = var.zone_id
  name    = "fm3._domainkey"
  type    = "CNAME"
  content = "fm3.${var.zone_name}.dkim.fmhosted.com"
  ttl     = 1
}

resource "cloudflare_dns_record" "spf" {
  zone_id = var.zone_id
  name    = "@"
  content = "v=spf1 ${join(" ", concat(["include:spf.messagingengine.com"], var.spf_terms, ["-all"]))}"
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_dns_record" "dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc"
  content = "v=DMARC1; p=reject; rua=mailto:${join(",mailto:", var.dmarc_rua)}; ruf=mailto:${join(",mailto:", var.dmarc_ruf)}; fo=1:d:s"
  type    = "TXT"
  ttl     = 1
}

module "mta_sts" {
  source  = "rsclarke/mta-sts/cloudflare"
  version = "~>2.0"

  account_id = var.account_id
  zone_id    = var.zone_id
  zone_name  = var.zone_name

  mode    = var.mta_sts_mode
  mx      = concat([cloudflare_dns_record.mx1.content, cloudflare_dns_record.mx2.content], var.mta_sts_mx)
  max_age = var.mta_sts_max_age
  rua     = var.tlsrpt_rua
}
