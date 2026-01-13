#!/bin/bash

# Nginx Installing Script

#Checking operating system's package manager

if command -v apt &> /dev/null; then
    echo "APT is available"
    sudo apt update
    sudo apt install nginx -y
elif command -v yum &> /dev/null; then
    echo "YUM is available"
    echo "Installing prerequisites"
    yum install yum-utils -y
    cat << EOF | tee /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF
    yum install nginx -y
elif command -v dnf &> /dev/null; then
    echo "DNF is available"
    dnf update -y
    dnf install nginx -y
else
    echo "No supported Package Manager found"
    exit 1
fi

# Check if nginx is running
if systemctl is-active --quiet nginx; then
    echo "Nginx is running successfully"
    echo "<html><body><h1>Welcome to My NGINX Server! Installed via shell script.</h1></body></html>" | sudo tee /var/www/html/index.html > /dev/null
    sudo systemctl restart nginx
    echo "Content of page is:"
    curl localhost:80
else
    echo "Nginx service is not running, starting it now..."
    sudo systemctl enable nginx
    systemctl restart nginx
    
    # Verify it started
    if systemctl is-active --quiet nginx; then
        echo "Nginx started and running successfully"
        echo "<html><body><h1>Welcome to My NGINX Server! Installed via shell script.</h1></body></html>" | sudo tee /var/www/html/index.html > /dev/null
        sudo systemctl restart nginx
        echo "Content of page is:"
        curl localhost:80
    else
        echo "Failed to start nginx, kindly re-check"
        exit 1
    fi
fi