resource "shoreline_notebook" "ssh_connection_timeouts" {
  name       = "ssh_connection_timeouts"
  data       = file("${path.module}/data/ssh_connection_timeouts.json")
  depends_on = [shoreline_action.invoke_server_check_ssh_service,shoreline_action.invoke_firewall_setup]
}

resource "shoreline_file" "server_check_ssh_service" {
  name             = "server_check_ssh_service"
  input_file       = "${path.module}/data/server_check_ssh_service.sh"
  md5              = filemd5("${path.module}/data/server_check_ssh_service.sh")
  description      = "Verify that the server is up and running and that the SSH service is running. Restart the SSH service if necessary."
  destination_path = "/tmp/server_check_ssh_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "firewall_setup" {
  name             = "firewall_setup"
  input_file       = "${path.module}/data/firewall_setup.sh"
  md5              = filemd5("${path.module}/data/firewall_setup.sh")
  description      = "Check the firewall settings on the server and ensure that SSH traffic is allowed."
  destination_path = "/tmp/firewall_setup.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_server_check_ssh_service" {
  name        = "invoke_server_check_ssh_service"
  description = "Verify that the server is up and running and that the SSH service is running. Restart the SSH service if necessary."
  command     = "`chmod +x /tmp/server_check_ssh_service.sh && /tmp/server_check_ssh_service.sh`"
  params      = ["SERVER_IP"]
  file_deps   = ["server_check_ssh_service"]
  enabled     = true
  depends_on  = [shoreline_file.server_check_ssh_service]
}

resource "shoreline_action" "invoke_firewall_setup" {
  name        = "invoke_firewall_setup"
  description = "Check the firewall settings on the server and ensure that SSH traffic is allowed."
  command     = "`chmod +x /tmp/firewall_setup.sh && /tmp/firewall_setup.sh`"
  params      = ["SERVER_IP_ADDRESS_OR_HOSTNAME","SSH_PORT_NUMBER"]
  file_deps   = ["firewall_setup"]
  enabled     = true
  depends_on  = [shoreline_file.firewall_setup]
}

