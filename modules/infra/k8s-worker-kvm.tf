resource "libvirt_volume" "node" {
  count            = var.cluster_specification.node
  name             = "${var.node_domain.node_name}-${count.index}.qcow2"
  pool             = libvirt_pool.cluster.name
  size             = var.node_domain.node_volume
  format           = "qcow2"
  base_volume_id   = libvirt_volume.common-qcow2.id
  base_volume_pool = "iso_pool"
}

data "template_file" "user_data_node" {
  count    = var.cluster_specification.node
  template = file("${path.module}/configuration/cloud_init.cfg")
  vars = {
    authorized_key = var.ssh_public_key
    hostname       = "${var.node_domain.node_name}-${count.index}"
  }
}

data "template_file" "network_config_node" {
  # count    = var.cluster_specification.node
  template = file("${path.module}/configuration/network_config.cfg")
  # vars = {
  #   mac = "${var.node_domain.interface_mac[count.index]}"
  # }  
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit-node" {
  count          = var.cluster_specification.node
  name           = "commoninit-node-${count.index}.iso"
  user_data      = data.template_file.user_data_node[count.index].rendered
  network_config = data.template_file.network_config_node.rendered
  pool           = libvirt_pool.cluster.name
}

# Create the machine
resource "libvirt_domain" "domain-node" {
  count  = var.cluster_specification.node
  name   = "${var.node_domain.node_name}-${count.index}"
  memory = var.node_domain.ram_size
  vcpu   = var.node_domain.cpu_count

  cloudinit = libvirt_cloudinit_disk.commoninit-node[count.index].id

  network_interface {
    bridge = var.node_domain.network_interface
    mac    = var.cluster_interface_mac.node[count.index]
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.node[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
