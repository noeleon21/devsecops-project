#!/usr/bin/env bash

# Update packages
sudo dnf update -y

# Install MariaDB 10.5 (if available in your DNF repos)
sudo dnf install -y mariadb-server

# Start and enable MariaDB service
sudo systemctl start mariadb
sudo systemctl enable mariadb
