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
