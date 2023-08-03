resource "shoreline_notebook" "mysql_slave_replication_lag" {
  name       = "mysql_slave_replication_lag"
  data       = file("${path.module}/data/mysql_slave_replication_lag.json")
  depends_on = [shoreline_action.invoke_ping_traceroute_servers,shoreline_action.invoke_mysql_master_slave_setup,shoreline_action.invoke_ping_check_mysql_connectivity,shoreline_action.invoke_mysql_replication_config]
}

resource "shoreline_file" "ping_traceroute_servers" {
  name             = "ping_traceroute_servers"
  input_file       = "${path.module}/data/ping_traceroute_servers.sh"
  md5              = filemd5("${path.module}/data/ping_traceroute_servers.sh")
  description      = "Check the network connectivity and latency between the master and slave servers"
  destination_path = "/agent/scripts/ping_traceroute_servers.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "mysql_master_slave_setup" {
  name             = "mysql_master_slave_setup"
  input_file       = "${path.module}/data/mysql_master_slave_setup.sh"
  md5              = filemd5("${path.module}/data/mysql_master_slave_setup.sh")
  description      = "Define variables"
  destination_path = "/agent/scripts/mysql_master_slave_setup.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ping_check_mysql_connectivity" {
  name             = "ping_check_mysql_connectivity"
  input_file       = "${path.module}/data/ping_check_mysql_connectivity.sh"
  md5              = filemd5("${path.module}/data/ping_check_mysql_connectivity.sh")
  description      = "Check network connectivity"
  destination_path = "/agent/scripts/ping_check_mysql_connectivity.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "mysql_replication_config" {
  name             = "mysql_replication_config"
  input_file       = "${path.module}/data/mysql_replication_config.sh"
  md5              = filemd5("${path.module}/data/mysql_replication_config.sh")
  description      = "Check the configuration of the MySQL replication process and ensure that it is correctly set up."
  destination_path = "/agent/scripts/mysql_replication_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ping_traceroute_servers" {
  name        = "invoke_ping_traceroute_servers"
  description = "Check the network connectivity and latency between the master and slave servers"
  command     = "`chmod +x /agent/scripts/ping_traceroute_servers.sh && /agent/scripts/ping_traceroute_servers.sh`"
  params      = ["SLAVE_SERVER","MASTER_SERVER"]
  file_deps   = ["ping_traceroute_servers"]
  enabled     = true
  depends_on  = [shoreline_file.ping_traceroute_servers]
}

resource "shoreline_action" "invoke_mysql_master_slave_setup" {
  name        = "invoke_mysql_master_slave_setup"
  description = "Define variables"
  command     = "`chmod +x /agent/scripts/mysql_master_slave_setup.sh && /agent/scripts/mysql_master_slave_setup.sh`"
  params      = ["MASTER_MYSQL_SERVER_IP","SLAVE_MYSQL_SERVER_IP"]
  file_deps   = ["mysql_master_slave_setup"]
  enabled     = true
  depends_on  = [shoreline_file.mysql_master_slave_setup]
}

resource "shoreline_action" "invoke_ping_check_mysql_connectivity" {
  name        = "invoke_ping_check_mysql_connectivity"
  description = "Check network connectivity"
  command     = "`chmod +x /agent/scripts/ping_check_mysql_connectivity.sh && /agent/scripts/ping_check_mysql_connectivity.sh`"
  params      = ["MASTER_SERVER"]
  file_deps   = ["ping_check_mysql_connectivity"]
  enabled     = true
  depends_on  = [shoreline_file.ping_check_mysql_connectivity]
}

resource "shoreline_action" "invoke_mysql_replication_config" {
  name        = "invoke_mysql_replication_config"
  description = "Check the configuration of the MySQL replication process and ensure that it is correctly set up."
  command     = "`chmod +x /agent/scripts/mysql_replication_config.sh && /agent/scripts/mysql_replication_config.sh`"
  params      = []
  file_deps   = ["mysql_replication_config"]
  enabled     = true
  depends_on  = [shoreline_file.mysql_replication_config]
}

