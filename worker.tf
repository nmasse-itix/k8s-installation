resource "libvirt_cloudinit_disk" "worker_cloudinit" {
  name           = "worker-cloudinit.iso"
  user_data      = data.template_file.worker_user_data.rendered
  network_config = data.template_file.worker_network_config.rendered
  pool           = libvirt_pool.cluster_storage.name
}

data "template_file" "worker_user_data" {
  template = file("${path.module}/templates/base/cloud-init.cfg")
}

data "template_file" "worker_network_config" {
  template = file("${path.module}/templates/base/network-config.cfg")
}

resource "libvirt_volume" "worker_disk" {
  name             = "${format(local.worker_format, count.index + 1)}.${var.volume_format}"
  count            = var.worker_nodes
  format           = var.volume_format
  pool             = libvirt_pool.cluster_storage.name
  base_volume_name = "${var.ubuntu_image}.${var.volume_format}"
  base_volume_pool = var.base_image_pool
  size             = var.worker_disk_size
}

locals {
  worker_nodes = [for i in range(var.worker_nodes) : {
    name = format(local.worker_format, i + 1)
    ip   = cidrhost(var.network_ip_range, 21 + i)
    mac  = format(var.network_mac_format, 21 + i)
    role = "worker"
  }]
}

resource "libvirt_domain" "worker" {
  count           = var.worker_nodes
  name            = format(local.worker_format, count.index + 1)
  vcpu            = var.worker_vcpu
  memory          = var.worker_memory_size
  cloudinit       = libvirt_cloudinit_disk.master_cloudinit.id
  autostart       = false

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = element(libvirt_volume.worker_disk.*.id, count.index)
  }

  # Makes the tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
  }

  network_interface {
    network_name   = var.network_name
    mac            = element(local.worker_nodes.*.mac, count.index)
    wait_for_lease = false
  }

  xml {
    xslt = file("${path.module}/portgroups/${var.network_portgroup}.xslt")
  }
}
