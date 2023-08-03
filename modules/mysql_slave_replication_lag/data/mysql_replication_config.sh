bash

#!/bin/bash

# Stop the MySQL service

sudo systemctl stop mysql.service

# Backup the my.cnf file

sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak

# Edit the my.cnf file

sudo sed -i 's/^server-id/#server-id/' /etc/mysql/my.cnf

sudo sed -i 's/^log_bin/#log_bin/' /etc/mysql/my.cnf

sudo sed -i 's/^binlog_do_db/#binlog_do_db/' /etc/mysql/my.cnf

sudo sed -i 's/^replicate_do_db/#replicate_do_db/' /etc/mysql/my.cnf

# Start the MySQL service

sudo systemctl start mysql.service

echo "MySQL replication configuration has been checked and updated."