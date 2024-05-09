output "public_ip_1" {
  description = "IP PUBLIC Maquina 1"
  value       = aws_instance.ec2_instance_linux1.public_ip
}

output "public_ip_2" {
  description = "IP PUBLIC Maquina 2"
  value       = aws_instance.ec2_instance_linux2.public_ip
}

output "name" {
  description = "Id do EFS"
  value       = aws_efs_file_system.decatlhombikescompa.id
}
