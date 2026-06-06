###############################################################################
# cloud-init: first-boot configuration ISO.
###############################################################################

locals {
  user_data = templatefile("${path.module}/cloud-init/user-data.yaml.tftpl", {
    hostname             = var.vm_name
    fqdn                 = "${var.vm_name}.${var.network_domain}"
    timezone             = var.timezone
    normal_user          = var.normal_user
    agents_user          = var.agents_user
    ssh_authorized_key   = trimspace(tls_private_key.ssh.public_key_openssh)
    agents_allowed_ports = join(", ", [for p in var.agents_allowed_ports : tostring(p)])
  })

  network_config = file("${path.module}/cloud-init/network-config.yaml")
}

resource "libvirt_cloudinit_disk" "sandbox" {
  name           = "${var.vm_name}-cloudinit.iso"
  pool           = var.pool_name
  user_data      = local.user_data
  network_config = local.network_config
}
