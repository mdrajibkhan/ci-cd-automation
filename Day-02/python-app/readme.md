# My Python App

Local run:
```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
FLASK_APP=app.py flask run -p 8000


================


---

# 2) One‑time server prep (RHEL/AlmaLinux)

Run these **once** (as root or via sudo) on the target server (e.g., `almalinux9`):

```bash
# Create a deploy user (adjust name if you like)
sudo useradd -m -s /bin/bash deploy || true
sudo mkdir -p ~deploy/.ssh && sudo chmod 700 ~deploy/.ssh
# Paste your GitHub Actions runner's public key into:
#   /home/deploy/.ssh/authorized_keys
sudo bash -c 'cat >> /home/deploy/.ssh/authorized_keys'  # then paste key, Ctrl-D
sudo chown -R deploy:deploy ~deploy/.ssh
sudo chmod 600 ~deploy/.ssh/authorized_keys

# System packages
sudo dnf -y update
sudo dnf -y install python3 python3-pip python3-venv git

# App directory
sudo mkdir -p /opt/myapp
sudo chown -R deploy:deploy /opt/myapp

# Open firewall for port 8000 (change if you reverse-proxy with NGINX)
sudo firewall-cmd --add-port=8000/tcp --permanent
sudo firewall-cmd --reload

# (SELinux is enforcing by default; no change needed if using TCP:8000)
# If you later reverse-proxy with NGINX on :80/:443, set that up separately.

==============================
Required GitHub Secrets

Create these in Repo → Settings → Secrets and variables → Actions → New repository secret:

SSH_HOST — server IP or DNS

SSH_USER — typically deploy

SSH_PRIVATE_KEY — private key text that matches the public key you put in /home/deploy/.ssh/authorized_keys

(Optional) SSH_PORT — default 22

(Optional) PUBLIC_APP_HOST — public DNS if different from SSH_HOST
