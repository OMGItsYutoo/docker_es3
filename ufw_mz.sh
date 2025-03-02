#!/bin/bash

# Install UFW
apt-get update
apt-get install -y ufw

# Default policies
ufw default deny incoming
ufw default deny outgoing

# Allow SSH
ufw allow in on eth0 to any port 22

# Allow HTTP and HTTPS traffic
ufw allow in on eth0 to any port 80
ufw allow in on eth0 to any port 443

# Allow MySQL traffic
ufw allow in on eth0 to any port 3306

# Enable UFW
ufw --force enable

# Keep the container running
tail -f /dev/null