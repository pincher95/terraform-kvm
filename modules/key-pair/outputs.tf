# output "bootstrap_key" {
#   value = aws_key_pair.server_key.*.id
# }

output "cluster_private_key" {
  # value = tls_private_key.server_key[0].private_key_pem
  value     = tls_private_key.server_key.private_key_pem
  sensitive = true
}

output "cluster_public_key" {
  # value = tls_private_key.server_key[0].public_key_pem
  value     = tls_private_key.server_key.public_key_openssh
  sensitive = false
}
