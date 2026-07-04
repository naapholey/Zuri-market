output "public_ip" {
  value = aws_instance.k3s.public_ip
}

output "public_dns" {
  value = aws_instance.k3s.public_dns
}

output "instance_id" {
  value = aws_instance.k3s.id
}
output "ec2_public_ip" {
  value = aws_instance.k3s.public_ip
}