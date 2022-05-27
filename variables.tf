variable "master_nodes" {
  type    = number
  default = 3
}

variable "worker_nodes" {
  type    = number
  default = 2
}

variable "volume_format" {
  type    = string
  default = "qcow2"
}

variable "centos_image" {
  type    = string
  default = "centos-stream-8"
}

variable "ubuntu_image" {
  type    = string
  default = "focal-server-cloudimg-amd64"
}

variable "cluster_name" {
  type    = string
  default = "k8s"
}

variable "base_domain" {
  type    = string
  default = "itix.lab"
}

variable "network_name" {
  type    = string
  default = "lab"
}

variable "network_portgroup" {
  type    = string
  default = "lab7"
}

variable "network_ip_range" {
  type    = string
  default = "192.168.7.0/24"
}

variable "network_mac_format" {
  type    = string
  default = "02:01:07:00:07:%02x"
}

variable "master_disk_size" {
  type    = number
  default = 120 * 1024 * 1024 * 1024
}

variable "master_vcpu" {
  type    = number
  default = 2
}

variable "master_memory_size" {
  type    = number
  default = 10 * 1024
}

variable "lb_disk_size" {
  type    = number
  default = 10 * 1024 * 1024 * 1024
}

variable "lb_vcpu" {
  type    = number
  default = 2
}

variable "lb_memory_size" {
  type    = number
  default = 4 * 1024
}

variable "storage_disk_size" {
  type    = number
  default = 120 * 1024 * 1024 * 1024
}

variable "storage_vcpu" {
  type    = number
  default = 2
}

variable "storage_memory_size" {
  type    = number
  default = 8 * 1024
}

variable "worker_disk_size" {
  type    = number
  default = 120 * 1024 * 1024 * 1024
}

variable "worker_vcpu" {
  type    = number
  default = 2
}

variable "worker_memory_size" {
  type    = number
  default = 8 * 1024
}

variable "base_image_pool" {
  type    = string
  default = "base-images"
}

locals {
  master_format  = "${var.cluster_name}-master-%02d"
  worker_format  = "${var.cluster_name}-worker-%02d"
  storage_name   = "${var.cluster_name}-storage"
  lb_name        = "${var.cluster_name}-lb"
  network_domain = "${var.cluster_name}.${var.base_domain}"
}
