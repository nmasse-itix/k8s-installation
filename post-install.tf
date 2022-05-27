resource "local_file" "registry_pv" {
  content         = templatefile("${path.module}/templates/registry-pv.yaml", { nfs_server = local.storage_node.ip })
  filename        = ".clusters/${var.cluster_name}/registry-pv.yaml"
  file_permission = "0644"
}

resource "local_file" "nfs_provisioner" {
  content         = templatefile("${path.module}/templates/nfs-provisioner.yaml", { nfs_server = local.storage_node.ip })
  filename        = ".clusters/${var.cluster_name}/nfs-provisioner.yaml"
  file_permission = "0644"
}

resource "local_file" "ansible_inventory" {
  content         = templatefile("${path.module}/templates/inventory", { nodes = local.all_nodes })
  filename        = ".clusters/${var.cluster_name}/inventory"
  file_permission = "0644"
}
