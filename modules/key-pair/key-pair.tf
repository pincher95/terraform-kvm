locals {
  public_key_filename  = "${var.ssh_public_key_path}/${var.ssh_key_name[0]}.pub"
  private_key_filename = "${var.ssh_public_key_path}/${var.ssh_key_name[0]}"
}

resource "tls_private_key" "server_key" {
  # count     = length(var.ssh_key_name)
  algorithm = var.ssh_key_algorithm
  rsa_bits  = var.ssh_key_size
}

# resource "aws_key_pair" "server_key" {
#   count = length(var.key_pair)
#   key_name   = element(var.key_pair, count.index)
#   public_key = tls_private_key.server_key[count.index].public_key_openssh
# }

resource "local_file" "server_key_private" {
  depends_on = [tls_private_key.server_key]
  # count = length(var.key_name)
  # sensitive_content = tls_private_key.server_key[count.index].private_key_pem
  sensitive_content = tls_private_key.server_key.private_key_pem
  # filename = "${path.root}/keys/${element(var.key_name, count.index)}.pem"
  filename = local.private_key_filename
  file_permission = "0600"
}

resource "local_file" "server_key_public" {
  depends_on = [tls_private_key.server_key]
  # count = length(var.ssh_key_name)
  # sensitive_content = tls_private_key.server_key[count.index].public_key_pem
  sensitive_content = tls_private_key.server_key.public_key_openssh
  # filename = "${path.root}/keys/${element(var.key_name, count.index)}.pub"
  filename = local.public_key_filename
  file_permission = "0600"
}

# resource "local_file" "authorized_keys" {
#   count = length(var.key_pair)
#   sensitive_content = tls_private_key.server_key[count.index].public_key_openssh
#   filename = "../${path.root}/keys/authorized_keys"
#   file_permission = "0600"
# }