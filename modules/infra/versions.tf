terraform {
  required_providers {
    libvirt = {
      source = "example.com/dmacvicar/libvirt"
      version : ">= 0.6.3"
    }
  }
  required_version = ">= 0.13"
}