output "ip" {
  value = aws_instance.TestLamda.public_ip
}

output "ID_vm" {
  value = aws_instance.TestLamda.id
}