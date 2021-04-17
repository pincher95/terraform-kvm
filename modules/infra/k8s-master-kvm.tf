resource "libvirt_volume" "control" {
  count            = var.cluster_specification.control
  name             = "${var.control_domain.control_name}-${count.index}.qcow2"
  pool             = libvirt_pool.cluster.name
  size             = var.control_domain.control_volume
  format           = "qcow2"
  base_volume_id   = libvirt_volume.common-qcow2.id
  base_volume_pool = "iso_pool"
}

data "template_file" "user_data" {
  count    = var.cluster_specification.control
  template = file("${path.module}/configuration/cloud_init.cfg")
  vars = {
    authorized_key = var.ssh_public_key
    hostname       = "${var.control_domain.control_name}-${count.index}"
  }
}

data "template_file" "network_config" {
  # count    = var.cluster_specification.control
  template = file("${path.module}/configuration/network_config.cfg")
  # vars = {
  #   mac = "${var.control_domain.interface_mac[count.index]}"
  # }
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/control/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  count          = var.cluster_specification.control
  name           = "commoninit-control-${count.index}.iso"
  user_data      = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.cluster.name
}

# Create the machine
resource "libvirt_domain" "domain-control" {
  count  = var.cluster_specification.control
  name   = "${var.control_domain.control_name}-${count.index}"
  memory = var.control_domain.ram_size
  vcpu   = var.control_domain.cpu_count

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  network_interface {
    bridge = var.control_domain.network_interface
    mac = var.cluster_interface_mac.control[count.index]
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
    volume_id = libvirt_volume.control[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
