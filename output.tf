#outputs for for-each

output "linux-server-ip-adds" {
  value = [
    for instance in aws_instance.linux-server : instance.public_ip
  ]
}

output "linux-server-dns" {
  value = [for instance in aws_instance.linux-server : instance.public_dns]
}