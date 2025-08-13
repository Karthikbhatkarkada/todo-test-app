#!/bin/bash
set -e
cd /home/ubuntu/todo-app
npm install
sudo mkdir -p /var/www/todo-app
sudo cp -r * /var/www/todo-app/
sudo tee /etc/systemd/system/todo.service > /dev/null <<EOF
[Unit]
Description=Todo App
After=network.target

[Service]
ExecStart=/usr/bin/node /var/www/todo-app/server.js
Restart=always
User=ubuntu
Environment=PORT=80

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable todo
