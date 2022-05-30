resource "local_file" "nfs_provisioner" {
  content         = templatefile("${path.module}/templates/nfs-provisioner.yaml", { nfs_server = local.storage_node.ip })
  filename        = ".clusters/${var.cluster_name}/nfs-provisioner.yaml"
  file_permission = "0644"
}

resource "local_file" "ansible_inventory" {
  content         = templatefile("${path.module}/templates/inventory.yaml", { nodes = local.all_nodes, lb_ip = local.lb_node.ip })
  filename        = ".clusters/${var.cluster_name}/inventory.yaml"
  file_permission = "0644"
}
