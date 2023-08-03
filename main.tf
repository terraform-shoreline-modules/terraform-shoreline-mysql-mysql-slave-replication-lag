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

module "mysql_slave_replication_lag" {
  source    = "./modules/mysql_slave_replication_lag"

  providers = {
    shoreline = shoreline
  }
}