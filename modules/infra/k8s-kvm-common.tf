# We fetch the latest OS release image from their mirrors
resource "libvirt_volume" "common-qcow2" {
  name   = "${var.cluster_specification.os_vendor}.qcow2"
  pool   = "iso_pool"
  source = "${path.root}/cloudint-images/${var.cloud_image[var.cluster_specification.os_vendor]}"
  format = "qcow2"
}

resource "libvirt_pool" "cluster" {
  name = var.cluster_specification.cluster_name
  type = "dir"
  path = "/vm_storage_pool/kubernetes"
}
