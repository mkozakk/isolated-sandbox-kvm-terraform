###############################################################################
# Disks.
#
# Single merged OS+data disk: the Ubuntu cloud image is downloaded once as a
# read-only backing volume, and the VM gets one qcow2 disk (default 100 GB)
# layered on top of it.
###############################################################################

# Backing image, downloaded from the upstream cloud-images mirror on apply.
resource "libvirt_volume" "base" {
  name   = "${var.vm_name}-base.qcow2"
  pool   = var.pool_name
  source = var.ubuntu_image_url
  format = "qcow2"
}

# The VM's actual disk, backed by the base image and grown to disk_size_gb.
resource "libvirt_volume" "os" {
  name           = "${var.vm_name}.qcow2"
  pool           = var.pool_name
  base_volume_id = libvirt_volume.base.id
  format         = "qcow2"
  size           = var.disk_size_gb * 1024 * 1024 * 1024
}
