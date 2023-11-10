#!/bin/bash

# Verify that the server is up and running
if ! ping -c 1 ${SERVER_IP}; then
    echo "Server is down. Aborting."
    exit 1
fi

# Check if SSH service is running
if systemctl is-active sshd >/dev/null; then
    echo "SSH service is running."
else
    echo "SSH service is not running. Restarting now..."
    systemctl start sshd
    if systemctl is-active sshd >/dev/null; then
        echo "SSH service restarted successfully."
    else
        echo "Failed to restart SSH service."
        exit 1
    fi
fi