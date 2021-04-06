
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.6.7"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://${var.pve_host}:8006/api2/json"
  pm_user = var.pve_user
  pm_tls_insecure = true
}

/* Uses cloud-init options from Proxmox 5.2 */
resource "proxmox_vm_qemu" "cloudinit-test" {
  name = var.vm_name
  desc = "A test for using terraform and cloudinit"

  # Node name has to be the same name as within the cluster
  # this might not include the FQDN
  target_node = var.tgtnode

  # The destination resource pool for the new VM
  pool = ""

  # The template name to clone this vm from
  clone = var.clone_from

  # Activate QEMU agent for this VM
  agent = 1

  os_type = "cloud-init"
  cores = 2
  sockets = 1
  # Vcpus is set automatically by Proxmox to sockets * cores.
  vcpus = 0
  cpu = "host"
  memory = 2048

  # Setup the disk
  disk {
    size = "10G"
    type = "virtio"
    storage = "disk2"
    # iothread = 1
    # ssd = 1
    # discard = "on"
 }

  # Setup the network interface and assign a vlan tag: 256
  network {
    model = "virtio"
    bridge = "vmbr0"
    # tag = 256
  }

  # vmid should use the next available ID in the sequence.
  # vmid = 0

  ssh_user = var.ssh_user
  ssh_private_key = file("~/.ssh/id_ed25519")

  ipconfig0 = "${var.ipv4_address},gw=${var.ipv4_gateway}"
  # ipconfig0 = "192.168.1.103/24,gw=192.168.1.254"

  sshkeys = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2jnqvc8bOO9zXP2DF4HDwRyN8aqN6wc9Kxx2j7eJRL shizuki@DESKTOP-PSN7R74
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEak7cBVJojoJPFqs5az5n+f4aF3QYdtjagDOyabeTfa
EOF

}
