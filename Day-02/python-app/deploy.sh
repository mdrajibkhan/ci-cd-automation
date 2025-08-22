#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/opt/myapp"
SERVICE_FILE="/etc/systemd/system/myapp.service"

# Create venv if missing
if [ ! -d "${APP_DIR}/.venv" ]; then
  python3 -m venv "${APP_DIR}/.venv"
fi

# Install/Upgrade deps
source "${APP_DIR}/.venv/bin/activate"
pip install --upgrade pip
pip install -r "${APP_DIR}/requirements.txt"

# Write/refresh systemd unit if missing (idempotent)
if [ ! -f "${SERVICE_FILE}" ]; then
  sudo tee "${SERVICE_FILE}" > /dev/null <<'UNIT'
[Unit]
Description=My Python App (Gunicorn)
After=network.target

[Service]
User=deploy
Group=deploy
WorkingDirectory=/opt/myapp
Environment="PATH=/opt/myapp/.venv/bin"
ExecStart=/opt/myapp/.venv/bin/gunicorn -w 2 -b 0.0.0.0:8000 wsgi:application
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
UNIT
  sudo systemctl daemon-reload
  sudo systemctl enable myapp
else
  sudo systemctl daemon-reload
fi

# Restart to pick latest code
sudo systemctl restart myapp

# Health check (optional)
curl -fsS http://127.0.0.1:8000/healthz >/dev/null && echo "App healthy"
