
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# SSH Connection Timeouts.

SSH connection timeouts refer to a situation where a user is unable to establish a connection to a remote server or network device using the Secure Shell (SSH) protocol. This can occur due to a variety of reasons such as network connectivity issues, server overload, firewall restrictions, or misconfigured SSH settings. When this happens, users are unable to access the remote resources they need, which can lead to disruptions in business operations and productivity.

### Parameters

```shell
export REMOTE_SERVER="PLACEHOLDER"
export SERVER_IP="PLACEHOLDER"
export SERVER_IP_ADDRESS_OR_HOSTNAME="PLACEHOLDER"
export SSH_PORT_NUMBER="PLACEHOLDER"
```

## Debug

### Check network connectivity to the remote server

```shell
ping ${REMOTE_SERVER}
```

### Check if the remote server is reachable via SSH

```shell
ssh -v ${REMOTE_SERVER}
```

### Check if the remote server is listening on the SSH port

```shell
nc -zv ${REMOTE_SERVER} 22
```

### Check if the SSH service is running on the remote server

```shell
systemctl status sshd
```

### Check the SSH logs on the remote server for any errors

```shell
journalctl -u sshd | tail
```

### Check if there are any firewall rules blocking SSH traffic

```shell
iptables -L -n | grep 22
```

### Check the SSH configuration file for any errors

```shell
sshd -T | less
```

## Repair

### Verify that the server is up and running and that the SSH service is running. Restart the SSH service if necessary.

```shell
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
```

### Check the firewall settings on the server and ensure that SSH traffic is allowed.

```shell
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
```