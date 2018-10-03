#!/bin/bash
# This will install packges to display out of date packages on login as well as general server info. 
# It will also set up unatended security updates and a firewall to block all incoming except port 80, 443 and 22
# Usage ssh <your ssh config host> -t "$(<server-hardening.sh)"

# General packages
sudo apt update 
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install update-notifier-common -y
sudo apt install landscape-common -y
sudo apt update

# UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing 
sudo ufw allow proto tcp from any to any port 80,443
sudo ufw allow ssh
sudo ufw enable

# Unattended security updates
sudo apt install unattended-upgrades -y
echo "
// This is normally a much bigger file with multiple commented lines, this has been generated via a script so only includes what we need. If you need more options read the MAN page
Unattended-Upgrade::Allowed-Origins {
	"\${distro_id}:\${distro_codename}-security";
	"\${distro_id}ESM:\${distro_codename}";
};
" > /etc/apt/apt.conf.d/50unattended-upgrades
echo "
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "3";
APT::Periodic::Unattended-Upgrade "1";
" > /etc/apt/apt.conf.d/20auto-upgrades

# Clean up
echo "All required packages installed."
echo "Remember to:"
echo "* Add the pm2 save/resurrect commands"
echo "* Check who has root access"
echo "* Disable ssh password auth if required"


