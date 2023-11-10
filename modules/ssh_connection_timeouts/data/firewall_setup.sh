#!/bin/bash

# Set the parameters
SERVER=${SERVER_IP_ADDRESS_OR_HOSTNAME}
SSH_PORT=${SSH_PORT_NUMBER}

# Check the firewall settings
sudo iptables -L | grep "ACCEPT.*dport $SSH_PORT" | grep -q "tcp"
if [ $? -eq 0 ]
then
    echo "SSH traffic is already allowed on the firewall."
else
    echo "SSH traffic is not allowed on the firewall. Adding rule..."
    sudo iptables -A INPUT -p tcp --dport $SSH_PORT -j ACCEPT
    echo "SSH traffic is now allowed on the firewall."
fi