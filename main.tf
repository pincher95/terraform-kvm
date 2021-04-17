module "key_pair" {
  source              = "./modules/key-pair"
  ssh_key_name        = var.ssh_key_name
  ssh_key_algorithm   = var.ssh_key_algorithm
  ssh_key_size        = var.ssh_key_size
  ssh_public_key_path = var.ssh_public_key_path
}

module "infra" {
  source                = "./modules/infra"
  ssh_public_key        = module.key_pair.cluster_public_key
  cloud_image           = var.cloud_image
  cluster_specification = var.cluster_specification
  control_domain        = var.control_domain
  node_domain           = var.node_domain
  cluster_interface_mac = var.cluster_interface_mac
}
