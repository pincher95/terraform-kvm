terraform {
  required_providers {
    libvirt = {
      source = "example.com/dmacvicar/libvirt"
      version : ">= 0.6.3"
    }
    template = {
      source = "hashicorp/template"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = ">= 0.13"
}
