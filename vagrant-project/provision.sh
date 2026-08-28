#!/bin/bash
# ============================================================
# Vagrant Provisioning Script — Ubuntu Server 22.04
# Author: Israel
# Date: July 2026
# Description: Runs automatically when the VM is first created.
#              Updates the system, installs essential tools,
#              configures UFW, hardens SSH, and creates a
#              health check script.
# ============================================================

echo "=================================================="
echo "  STARTING AUTOMATED PROVISIONING"
echo "=================================================="

# ------------------------------------------------------------
# 1. SYSTEM UPDATE
# ------------------------------------------------------------
echo ""
echo "[1/6] Updating package lists and upgrading system..."
sudo apt-get update -y
sudo apt-get upgrade -y

# ------------------------------------------------------------
# 2. INSTALL ESSENTIAL TOOLS
# ------------------------------------------------------------
echo ""
echo "[2/6] Installing essential tools..."
sudo apt-get install -y \
    net-tools \
    curl \
    wget \
    nano \
    vim \
    htop \
    unzip \
    ufw \
    openssh-server \
    tree

# ------------------------------------------------------------
# 3. CONFIGURE FIREWALL (UFW)
# ------------------------------------------------------------
echo ""
echo "[3/6] Configuring UFW firewall rules..."

# Allow SSH so we don't lock ourselves out
sudo ufw allow OpenSSH
sudo ufw allow 22/tcp

# Allow ICMP (ping) for diagnostics
sudo ufw allow proto icmp from any to any

# Enable UFW non-interactively
sudo ufw --force enable

echo "Firewall status:"
sudo ufw status verbose

# ------------------------------------------------------------
# 4. SSH HARDENING
# ------------------------------------------------------------
echo ""
echo "[4/6] Hardening SSH configuration..."

SSH_CONFIG="/etc/ssh/sshd_config"

# Backup original config before modifying
sudo cp "$SSH_CONFIG" "$SSH_CONFIG.backup"

# Disable root login over SSH
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"

# Disable empty passwords
sudo sed -i 's/^#\?PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$SSH_CONFIG"

# Enable public key authentication (key-based auth ready)
sudo sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSH_CONFIG"

# Restart SSH to apply changes
sudo systemctl restart sshd

echo "SSH configuration hardened. Backup saved at $SSH_CONFIG.backup"

# ------------------------------------------------------------
# 5. HEALTH CHECK SCRIPT
# ------------------------------------------------------------
echo ""
echo "[5/6] Creating health check script..."

sudo tee /usr/local/bin/health-check.sh > /dev/null << 'HEALTHCHECK'
#!/bin/bash
# ============================================================
# Server Health Check Script
# Auto-generated during Vagrant provisioning
# ============================================================

echo "=================================================="
echo "  SERVER HEALTH CHECK — $(hostname)"
echo "  $(date)"
echo "=================================================="

echo ""
echo "[UPTIME]"
uptime

echo ""
echo "[DISK USAGE]"
df -h / | tail -1 | awk '{print "  Used: "$3" / "$2" ("$5" full)"}'

echo ""
echo "[MEMORY USAGE]"
free -h | grep Mem | awk '{print "  Used: "$3" / "$2}'

echo ""
echo "[CPU LOAD]"
uptime | awk -F'load average:' '{print "  Load average:"$2}'

echo ""
echo "[NETWORK]"
ip -4 addr show | grep inet | grep -v "127.0.0.1" | awk '{print "  IP: "$2}'

echo ""
echo "[FIREWALL STATUS]"
sudo ufw status | head -1

echo ""
echo "[SSH SERVICE]"
systemctl is-active sshd | awk '{print "  sshd status: "$1}'

echo ""
echo "=================================================="
echo "  HEALTH CHECK COMPLETE"
echo "=================================================="
HEALTHCHECK

sudo chmod +x /usr/local/bin/health-check.sh

echo "Health check script created at /usr/local/bin/health-check.sh"
echo "Run it anytime with: health-check.sh"

# ------------------------------------------------------------
# 6. FINAL SUMMARY
# ------------------------------------------------------------
echo ""
echo "[6/6] Provisioning complete. Running initial health check..."
echo ""
/usr/local/bin/health-check.sh

echo ""
echo "=================================================="
echo "  PROVISIONING FINISHED SUCCESSFULLY"
echo "=================================================="
