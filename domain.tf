###############################################################################
# The sandbox VM.
###############################################################################

resource "libvirt_domain" "sandbox" {
  name      = var.vm_name
  vcpu      = var.vcpus
  memory    = var.memory_mb
  autostart = true

  # NOTE: qemu_agent is intentionally left at its default (false). When enabled,
  # the provider waits for / queries the in-guest QEMU guest agent to report
  # interface addresses; if the agent isn't up yet that makes plan/apply fail
  # ("Guest agent is not responding"). We rely on DHCP leases for the IP
  # (wait_for_lease below) instead, which is deterministic at boot.

  cloudinit = libvirt_cloudinit_disk.sandbox.id

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.os.id
  }

  network_interface {
    network_id     = libvirt_network.sandbox.id
    wait_for_lease = true
  }

  # Serial console (virsh console <name>).
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  # Also expose the console over the virtio channel for `virsh console`.
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
