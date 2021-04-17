# ### The Ansible inventory file
# resource "local_file" "AnsibleInventory" {
#  content = templatefile("inventory.tmpl",
#  {
#   bastion-ip = aws_eip.eip-bastion.*.public_ip,
#   bastion-dns = ,
#   private-ip = aws_instance.i-private.*.private_ip,
#   bastion-dns =
#  }
#  )
#  filename = "inventory"
# }

# output "cluster_public_key" {
#   # value = tls_private_key.server_key[0].public_key_pem
#   value = var.ssh_public
# }

output "cluster-IPs" {          
    value = libvirt_domain.domain-node.*.network_interface[*]
}