# SIWES Server and Networking Operations Lab

# About This Repository

This repository documents my SIWES industrial training program, focused on Server and Networking Operations
It contains all scripts, diagrams, screenshots, documentation, and submissions produced throughout the program.

The lab environment is built using Oracle VirtualBox as the hypervisor to simulate a real-world server infrastructure.

## My Lab Topology

| Virtual Machine | Role | IP Address | OS |
|---|---|---|---|
| DC01 / FW01 | Firewall / Router (pfSense) | 192.168.100.1 | pfSense |
| WS01 | Domain Controller, DNS, DHCP | 192.168.100.10 | Windows Server 2022 |
| DNS01 / WEB01 | DNS, Web, Database Server | 192.168.100.20 | Ubuntu Server 22.04 |
| MGT01 | Management Host | 192.168.100.100 | Windows 11 |
