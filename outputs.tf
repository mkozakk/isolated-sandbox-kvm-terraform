output "vm_name" {
  description = "Name of the provisioned VM."
  value       = libvirt_domain.sandbox.name
}

output "vm_ip" {
  description = "DHCP-assigned IPv4 address of the VM."
  value       = try(libvirt_domain.sandbox.network_interface[0].addresses[0], null)
}

output "private_key_path" {
  description = "Path to the generated SSH private key."
  value       = local.private_key_path
}

output "ssh_normal_user" {
  description = "SSH command for the privileged human-developer account."
  value       = "ssh -i ${local.private_key_path} ${var.normal_user}@${try(libvirt_domain.sandbox.network_interface[0].addresses[0], "<vm-ip>")}"
}

output "ssh_agents_user" {
  description = "SSH command for the restricted AI-agent account."
  value       = "ssh -i ${local.private_key_path} ${var.agents_user}@${try(libvirt_domain.sandbox.network_interface[0].addresses[0], "<vm-ip>")}"
}
