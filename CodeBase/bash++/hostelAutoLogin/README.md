# Hostel Wi-Fi Auto Login (NetworkManager)

This repository contains a NetworkManager dispatcher script
to automatically log in and log out of a captive portal.

## Setup

1. Copy the script to:
   /etc/NetworkManager/dispatcher.d/90-hostel-autologin

2. Edit the script and replace:
   __USERNAME__
   __PASSWORD__

3. Make it executable:
   sudo chmod +x /etc/NetworkManager/dispatcher.d/90-hostel-autologin

4. Restart NetworkManager:
   sudo systemctl restart NetworkManager
