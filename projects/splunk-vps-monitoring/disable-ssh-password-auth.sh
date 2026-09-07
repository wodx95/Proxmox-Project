#!/bin/bash

# SSH Password Authentication Hardening Script
#
# Based on the SSH hardening process performed during my VPS security
# investigation. The original process was completed manually.
#
# This reusable version adds configuration backup and validation checks
# before reloading the SSH service.
#
# IMPORTANT:
# Public-key authentication must already be configured and tested.
# Otherwise disabling password authentication could lock me out of the server.


# Stop the script if a command fails.
set -e


# Path to the SSH configuration file that contained
# "PasswordAuthentication yes" on my VPS.
CONFIG="/etc/ssh/sshd_config.d/50-cloud-init.conf"

# Name of the backup file.
BACKUP="${CONFIG}.backup"


# STEP 1 - Create a backup of the SSH configuration.

echo "[+] Creating backup of SSH configuration..."

# Copy the original configuration before making any changes.
sudo cp "$CONFIG" "$BACKUP"


# STEP 2 - Disable password authentication.

echo "[+] Disabling password authentication..."

# Replace:
# PasswordAuthentication yes
# with:
# PasswordAuthentication no
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$CONFIG"


# STEP 3 - Check that the SSH configuration is still valid.

echo "[+] Validating SSH configuration..."

# sshd -t checks the SSH configuration for errors.
if sudo sshd -t; then

    echo "[+] SSH configuration is valid."

else

    # If the configuration is invalid, restore the backup.
    echo "[!] SSH configuration validation failed."
    echo "[!] Restoring original configuration..."

    sudo cp "$BACKUP" "$CONFIG"

    # Stop the script because the configuration failed validation.
    exit 1
fi


# STEP 4 - Reload SSH to apply the new configuration.

echo "[+] Reloading SSH service..."

sudo systemctl reload ssh


# STEP 5 - Verify the effective SSH setting.

echo "[+] Verifying effective SSH configuration..."

# The expected result is:
# passwordauthentication no
sudo sshd -T | grep passwordauthentication


echo "[+] SSH password authentication has been disabled successfully."
echo "[+] Public-key authentication should now be used for remote access."
