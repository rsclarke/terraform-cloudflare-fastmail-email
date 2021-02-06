resource "cloudflare_record" "mx1" {
  zone_id  = var.zone_id
  name     = "@"
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  priority = 10
}

resource "cloudflare_record" "mx2" {
  zone_id  = var.zone_id
  name     = "@"
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  priority = 20
}

resource "cloudflare_record" "dkim1" {
  zone_id = var.zone_id
  name    = "fm1._domainkey"
  type    = "CNAME"
  value   = "fm1.${var.zone_name}.dkim.fmhosted.com"
}

resource "cloudflare_record" "dkim2" {
  zone_id = var.zone_id
  name    = "fm2._domainkey"
  type    = "CNAME"
  value   = "fm2.${var.zone_name}.dkim.fmhosted.com"
}

resource "cloudflare_record" "dkim3" {
  zone_id = var.zone_id
  name    = "fm3._domainkey"
  type    = "CNAME"
  value   = "fm3.${var.zone_name}.dkim.fmhosted.com"
}

resource "cloudflare_record" "spf" {
  zone_id = var.zone_id
  name    = "@"
  value   = "v=spf1 ${join(" ", concat(["include:spf.messagingengine.com"], var.spf_terms, ["-all"]))}"
  type    = "TXT"
}

resource "cloudflare_record" "dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc"
  value   = "v=DMARC1; p=reject; rua=mailto:${join(",mailto:", var.dmarc_rua)}; ruf=mailto:${join(",mailto:", var.dmarc_ruf)}; fo=1:d:s"
  type    = "TXT"
}
