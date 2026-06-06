###############################################################################
# NAT network with DNS + DHCP.
###############################################################################

resource "libvirt_network" "sandbox" {
  name      = var.network_name
  mode      = "nat"
  domain    = var.network_domain
  addresses = [var.network_cidr]
  autostart = true

  dhcp {
    enabled = true
  }

  dns {
    enabled    = true
    local_only = false
  }
}
