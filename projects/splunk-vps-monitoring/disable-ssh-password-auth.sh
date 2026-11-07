#!/bin/bash

# SSH Password Authentication Hardening Script
#
# Based on the SSH hardening process performed during my VPS security
# investigation. The original process was completed manually.
#
# This reusable version adds configuration backup and validation checks
# before reloading the SSH service, and confirms that the effective
# setting really changed.
#
# IMPORTANT:
# Public-key authentication must already be configured and tested.
# Otherwise disabling password authentication could lock me out of the server.
# Keep an existing SSH session open until a new key-based login has been tested.


# Stop the script if a command fails, an unset variable is used,
# or a command in a pipeline fails.
set -euo pipefail


# Path to the SSH configuration file that contained
# "PasswordAuthentication yes" on my VPS.
CONFIG="/etc/ssh/sshd_config.d/50-cloud-init.conf"

# Timestamped backup so that running the script again
# does not overwrite the original backup.
BACKUP="${CONFIG}.backup.$(date +%Y%m%d-%H%M%S)"


# STEP 0 - Safety checks.

# Make sure the configuration file exists before changing it.
if [ ! -f "$CONFIG" ]; then
    echo "[!] $CONFIG not found. Check where PasswordAuthentication is set:"
    echo "    sudo grep -ri passwordauthentication /etc/ssh/"
    exit 1
fi

# Warn if the current user has no authorised SSH keys.
if [ ! -s "$HOME/.ssh/authorized_keys" ]; then
    echo "[!] No keys found in $HOME/.ssh/authorized_keys."
    echo "[!] Configure and test key-based login before running this script."
    exit 1
fi


# STEP 1 - Create a backup of the SSH configuration.

echo "[+] Creating backup of SSH configuration: $BACKUP"

# Copy the original configuration before making any changes.
sudo cp "$CONFIG" "$BACKUP"


# STEP 2 - Disable password authentication.

echo "[+] Disabling password authentication..."

# Replace any existing PasswordAuthentication line (yes, commented out,
# any spacing or case) with "PasswordAuthentication no".
# If the line does not exist, add it.
if sudo grep -qiE '^\s*#?\s*PasswordAuthentication' "$CONFIG"; then
    sudo sed -i -E 's/^\s*#?\s*PasswordAuthentication.*/PasswordAuthentication no/I' "$CONFIG"
else
    echo "PasswordAuthentication no" | sudo tee -a "$CONFIG" > /dev/null
fi


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


# STEP 4 - Verify the effective SSH setting BEFORE reloading.

echo "[+] Verifying effective SSH configuration..."

# sshd uses the first value it finds, so another file
# (for example the main sshd_config) could still enable passwords.
# sshd -T shows the setting that will actually be used.
EFFECTIVE=$(sudo sshd -T | grep -i '^passwordauthentication' | awk '{print $2}')

if [ "$EFFECTIVE" != "no" ]; then
    echo "[!] Effective setting is still: passwordauthentication $EFFECTIVE"
    echo "[!] Another file overrides it. Check with:"
    echo "    sudo grep -ri passwordauthentication /etc/ssh/"
    echo "[!] Restoring original configuration..."
    sudo cp "$BACKUP" "$CONFIG"
    exit 1
fi

echo "[+] Effective setting: passwordauthentication no"


# STEP 5 - Reload SSH to apply the new configuration.

echo "[+] Reloading SSH service..."

# The service is called "ssh" on Ubuntu/Debian and "sshd" on many other distributions.
if systemctl list-unit-files ssh.service > /dev/null 2>&1; then
    sudo systemctl reload ssh
else
    sudo systemctl reload sshd
fi


echo "[+] SSH password authentication has been disabled successfully."
echo "[+] Test a new key-based login before closing this session."
