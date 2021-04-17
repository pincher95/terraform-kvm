#----------key-pair--------------------
# variable "project_key_path" {
#   description = "Path to private project key"
#   type        = string
#   default     = "../keys/project.pem"
# }

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key directory (e.g. `/secrets`)"
  default     = "$HOME/.ssh"
}

variable "ssh_key_name" {
  type        = any
  description = "SSH key name"
  default     = ["id_rsa_k8s"]
  #default = ["project_key", "jenkins_key", "bastion_key"]
}

variable "ssh_key_algorithm" {
  type        = string
  description = "SSH key algorithm"
  default     = "RSA"
}

variable "ssh_key_size" {
  type        = number
  description = "SSH bits size"
  default     = 4096
}

variable "cloud_image" {
  type        = map(any)
  description = "Cloud images map"
  default = {
    "ubuntu-18.04"       = "ubuntu-18.04-server-cloudimg-amd64.img"
    "ubuntu-20.04"       = "ubuntu-20.04-server-cloudimg-amd64.img"
    "centos-7.9"         = "CentOS-7-x86_64-GenericCloud-2009.qcow2"
    "centos-stream-8.3"  = "CentOS-Stream-GenericCloud-8-20200113.0.x86_64.qcow2"
    "debian-buster-10"   = "debian-10-genericcloud-amd64-20210208-542.qcow2"
    "opensuse-leap-15.2" = "openSUSE-Leap-15.2.x86_64-NoCloud.qcow2"
    "rhel-7.9"           = "rhel-server-7.9-x86_64-kvm.qcow2"
    "rhel-8.3"           = "rhel-8.3-update-2-x86_64-kvm.qcow2"
  }
}

# variable "os_vendor_ver" {
#   type        = string
#   description = "OS vendor"
#   default     = "ubuntu-18.04"
# }

variable "control_domain" {
  type        = map(any)
  description = "Control plain domain configuration"
  default = {
    cpu_count         = "2"
    ram_size          = "4096"
    network_interface = "br0"
    control_volume    = 1073741824 * 10
    control_name      = "k8s-control"
  }
}

variable "node_domain" {
  type        = map(any)
  description = "Node domain configuration"
  default = {
    cpu_count         = "2"
    ram_size          = "4096"
    network_interface = "br0"
    node_volume       = 1073741824 * 10
    node_name         = "k8s-node"
  }
}

variable "cluster_specification" {
  type        = map(any)
  description = "Common cluster specification"
  default = {
    cluster_name = "k8s-cluster"
    os_vendor    = "centos-7.9"
    control      = "1"
    node         = "3"
  }
}

variable "cluster_interface_mac" {
  type        = map(any)
  description = "Fixed interface MAC address for DHCP reservation use"
  default = {
    control = ["52:54:00:d6:06:2a"]
    node    = ["52:54:00:4a:58:cf", "52:54:00:f2:e5:7a", "52:54:00:be:ad:7b"]
  }
}

# variable "recordsets" {
#   type = list(object({
#     name    = string
#     type    = string
#     ttl     = number
#     records = list(string)
#   }))
# }
