#!/bin/bash

# MySQL Installing Script

echo "Starting MySQL secure installation automation..."

NEW_ROOT_PASSWORD="MyS3cure#Pass2026!"
sudo apt update
sudo apt install mysql-server -y

if systemctl is-active --quiet mysql; then
    echo "Mysql server is running successfully"
else
    sudo systemctl enable mysql
    sudo systemctl restart mysql
    if systemctl is-active --quiet mysql; then
        echo "Mysql server is running successfully"
    else
        echo "Failed to restart Mysql"
        exit 1
    fi
fi

echo "Using direct MySQL commands method..."
#setting password with policies: at least 12 characters with uppercase, lowercase, numbers, and special characters.
mysql -u root <<-EOSQL
    -- Install and configure password validation plugin
    INSTALL COMPONENT 'file://component_validate_password';
    
    -- Set strong password policies
    SET GLOBAL validate_password.policy = STRONG;
    SET GLOBAL validate_password.length = 12;
    SET GLOBAL validate_password.mixed_case_count = 1;
    SET GLOBAL validate_password.number_count = 1;
    SET GLOBAL validate_password.special_char_count = 1;

     -- Update root password
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${NEW_ROOT_PASSWORD}';
    
    -- Remove anonymous users
    DELETE FROM mysql.user WHERE User='';
    
    -- Disallow root login remotely
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    
    -- Remove test database
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    
    -- Reload privilege tables
    FLUSH PRIVILEGES;

EOSQL

echo "MySQL secure installation completed successfully!"
echo "Root password has been set/updated."
echo "Anonymous users removed."
echo "Remote root login disabled."
echo "Test database removed."
echo "Strong password policies enabled."

#innodb_buffer_pool_size decides how much RAM MySQL uses to keep data ready for fast access.
# Calculate 50% of available RAM in MB
TOTAL_RAM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
BUFFER_POOL_SIZE=$((TOTAL_RAM / 2/ 1024))M

#finding mysql configuration file
MYSQL_CNF="/etc/mysql/mysql.conf.d/mysqld.cnf"
echo "Updating MySQL configuration file: ${MYSQL_CNF}"

# Backup original configuration
BACKUP_FILE="${MYSQL_CNF}.backup.$(date +%Y%m%d_%H%M%S)"
echo "Creating backup: $BACKUP_FILE"
sudo cp "$MYSQL_CNF" "$BACKUP_FILE"

echo "Creating custom configuration file: $MYSQL_CNF"
sudo tee "$MYSQL_CNF" > /dev/null <<EOF
[mysqld]
# InnoDB Buffer Pool - Set to 50% of available RAM
innodb_buffer_pool_size = ${BUFFER_POOL_SIZE}

# Connection Settings
max_connections = 200

# Slow Query Log Settings
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 1
EOF


echo "updated custom configuration file successfully"

#Creating user and database and grant full privileges.
mysql -u root -p${NEW_ROOT_PASSWORD} <<-EOSQL
    CREATE DATABASE testdb;
    CREATE USER 'testuser'@'localhost' IDENTIFIED BY '${NEW_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON testdb.* TO 'testuser'@'localhost';
EOSQL
