# output "cluster_public_key" {
#   # value = tls_private_key.server_key[0].public_key_pem
#   value = module.infra.cluster_public_key
# }

output "cluster-IPs" {
    value = module.infra.cluster-IPs
}