# Automated Ubuntu Server Provisioning with Vagrant

Infrastructure as Code (IaC) project that provisions a complete, reproducible Ubuntu Server 22.04 environment with a single command.

---

## Why Infrastructure as Code?

Manual server setup doesn't scale and isn't reproducible. With this Vagrantfile, the entire environment can be destroyed and rebuilt identically at any time, by anyone, with one command. This is the same principle companies like Netflix, Google, and Amazon use to provision thousands of servers reliably.

---

## What This Builds

| Setting | Value |
|---|---|
| VM Name | dns02 |
| Base Box | `ubuntu/jammy64` (Ubuntu Server 22.04 LTS) |
| Static IP | `192.168.56.20` (Host-Only network) |
| RAM | 2048 MB |
| CPUs | 2 |
| Provider | Oracle VirtualBox |

---

## Requirements
- Hardware: 4GB RAM minimum, 20GB free disk space
- Software: VirtualBox 6.1+, Vagrant 2.3+
- Time: 3-4 hours (research + implementation)
- Internet: Required for downloading base boxes and packages

---

## Quick Start

```bash
# Clone or download this folder, then:
cd vagrant-project

# Build and provision the VM (one command does everything)
vagrant up

# SSH into the VM
vagrant ssh

# Run the built-in health check
health-check.sh

# Shut down when done
vagrant halt

# Completely remove the VM
vagrant destroy

# Rebuild it identically, any time
vagrant up
```

---

## What Gets Automated

The `provision.sh` script runs automatically on first boot and:

1. **Updates the system** — `apt-get update && apt-get upgrade`
2. **Installs essential tools** — curl, wget, nano, vim, htop, net-tools, tree, unzip
3. **Configures UFW firewall** — allows SSH + ICMP, enables the firewall
4. **Hardens SSH** — disables root login, disables empty passwords, enables key-based auth
5. **Creates a health check script** — `/usr/local/bin/health-check.sh` for on-demand diagnostics
6. **Runs an initial health check** — so you see the VM's status the moment provisioning finishes

---
