terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "ssh_connection_timeouts" {
  source    = "./modules/ssh_connection_timeouts"

  providers = {
    shoreline = shoreline
  }
}