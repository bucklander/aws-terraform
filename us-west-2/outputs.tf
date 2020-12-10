output "bastion_public_ip" {
  value = aws_eip.bastion.public_ip
}

output "alb_internal_dns_name" {
  value = aws_lb.alb-int-example.dns_name
}
