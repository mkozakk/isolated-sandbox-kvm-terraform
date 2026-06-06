# stega-tracker sandbox

One isolated Ubuntu 24.04 VM on local KVM/libvirt. Sandbox for running AI agents safely. Configured on first boot via cloud-init.

# Specs

- `dev-sandbox-1` — 8 vCPU, 18 GB RAM, 100 GB disk
- NAT network `10.10.10.0/24`, own DHCP + DNS
- Ubuntu 24.04 cloud image (auto-downloaded)
- XFCE desktop, autologin, over SPICE

# Deploy

Needs libvirt + KVM running, storage pool `default`.

```sh
terraform init     # once
terraform apply    # build
terraform destroy
```

Outputs print VM IP + SSH commands.

Rebuilds:
- SSH key regenerated each time (overwrites `.ssh/`)
- IP is DHCP, can change

# Connect

| Method | How |
|--------|-----|
| Shell | SSH command from `terraform output`, key-only |
| GUI | virt-manager / virt-viewer → SPICE, autologin as `user` |

SSH: key only, no passwords, no root.

# Users

| | `user` (me) | `agents` (AI) |
|---|---|---|
| sudo | full | none |
| docker | full | `docker` only, via sudoers |
| network | open | egress allowlist |
| GUI login | yes | no |

# Files

| File | Role |
|------|------|
| `versions.tf` | version pins |
| `providers.tf` | libvirt provider |
| `variables.tf` | knobs + defaults |
| `terraform.tfvars.example` | override template |
| `ssh.tf` | generates keypair |
| `network.tf` | NAT network |
| `volumes.tf` | base image + VM disk |
| `cloudinit.tf` | renders first-boot config |
| `domain.tf` | the VM |
| `outputs.tf` | IP + SSH commands |
| `cloud-init/user-data.yaml.tftpl` | all guest setup + hardening |
| `cloud-init/network-config.yaml` | guest DHCP |

`.ssh/`, `.terraform/`, `terraform.tfstate*` are generated.

# btw

Don't set `qemu_agent = true` 
