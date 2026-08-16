############################# ACM OUTPUT ##############################

output "cert_arns" {
  value       = aws_acm_certificate_validation.alb.certificate_arn
  description = "Validated ACM certificate ARNs"
}

output "domain_names" {
  value       = aws_acm_certificate.alb.domain_name
  description = "ACM certificate domain names"
}
