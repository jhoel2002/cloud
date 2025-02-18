output "ec2_public_ip" {
  description = "Ip publica de la instancia"
  value = [for instance in aws_instance.public_instance : instance.public_ip]
}