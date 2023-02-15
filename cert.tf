# resource "aws_acm_certificate" "invoacdmy-cert" {
#   domain_name       = "*.invoacdmy.com"
#   validation_method = "DNS"
# }

# resource "aws_route53_zone" "invoacdmy" {
#   name = "invoacdmy.com"
# }
# resource "aws_route53_record" "invoacdmy-record" {
#   for_each = {
#     for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

# #   allow_overwrite = true
# #   name            = each.value.name
# #   records         = [each.value.record]
# #   ttl             = 60
# #   type            = each.value.type
# #   zone_id         = data.aws_route53_zone.example.zone_id
# # }

# # resource "aws_acm_certificate_validation" "example" {
# #   certificate_arn         = aws_acm_certificate.example.arn
# #   validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
# # }

# # resource "aws_lb_listener" "example" {
# #   # ... other configuration ...

# #   certificate_arn = aws_acm_certificate_validation.example.certificate_arn
# # }
# # Alternative Domains DNS Validation with Route 53
# # resource "aws_acm_certificate" "example" {
# #   domain_name               = "example.com"
# #   subject_alternative_names = ["www.example.com", "example.org"]
# #   validation_method         = "DNS"
# # }

# # data "aws_route53_zone" "example_com" {
# #   name         = "example.com"
# #   private_zone = false
# # }

# # data "aws_route53_zone" "example_org" {
# #   name         = "example.org"
# #   private_zone = false
# # }

# # resource "aws_route53_record" "example" {
# #   for_each = {
# #     for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
# #       name    = dvo.resource_record_name
# #       record  = dvo.resource_record_value
# #       type    = dvo.resource_record_type
# #       zone_id = dvo.domain_name == "example.org" ? data.aws_route53_zone.example_org.zone_id : data.aws_route53_zone.example_com.zone_id
# #     }
# #   }

# #   allow_overwrite = true
# #   name            = each.value.name
# #   records         = [each.value.record]
# #   ttl             = 60
# #   type            = each.value.type
# #   zone_id         = each.value.zone_id
# # }

# # resource "aws_acm_certificate_validation" "example" {
# #   certificate_arn         = aws_acm_certificate.example.arn
# #   validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
# # }

# # resource "aws_lb_listener" "example" {
# #   # ... other configuration ...

# #   certificate_arn = aws_acm_certificate_validation.example.certificate_arn
# # }