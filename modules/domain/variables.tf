variable "alb_parameter" {
  description = "Aliasレコードとして登録するALBの情報"
  type = object({
    dns_name = string
    zone_id  = string
  })
}

variable "domain" {
  type        = string
  description = "ホストゾーンに設定するドメイン"
}
