#!/bin/bash

# Project Directory structure

set -e  # Exit on error

#Creating Directory Structure
mkdir -p project_workspace/{documentation,source_code,builds,logs,backups,shared}

#Creating Users
sudo useradd -m alice
sudo useradd -m bob
sudo useradd -m carol
sudo useradd -m eve
sudo useradd -m dan

#Creating Groups
sudo groupadd dev_team
sudo groupadd test_team
sudo groupadd backup_team
sudo groupadd admins
sudo groupadd everyone

# Creating users with Secondary groups
sudo usermod -aG dev_team alice
sudo usermod -aG dev_team bob
sudo usermod -aG test_team carol
sudo usermod -aG backup_team eve
sudo usermod -aG admins dan

# Adding all users to everyone group
for user in alice bob carol eve dan; do
    sudo usermod -aG everyone $user
done

#set ownership-explain
sudo chown alice:dev_team project_workspace/documentation
sudo chown bob:dev_team project_workspace/source_code
sudo chown dan:admins project_workspace/builds
sudo chown dan:admins project_workspace/logs
sudo chown eve:backup_team project_workspace/backups
sudo chown alice:everyone project_workspace/shared

# Set base permissions
sudo chmod 770 project_workspace/documentation
sudo chmod 750 project_workspace/source_code
sudo chmod 755 project_workspace/builds
sudo chmod 755 project_workspace/logs
sudo chmod 755 project_workspace/backups
sudo chmod 775 project_workspace/shared

#Setting ACL Permissions for directories
#for documentations-Only team members can read and modify
sudo setfacl -m g:dev_team:rwx project_workspace/documentation
sudo setfacl -d -m g:dev_team:rwx project_workspace/documentation

#for source_code-Only developers can read/write, and testers can only read
sudo setfacl -m g:dev_team:rwx project_workspace/source_code
sudo setfacl -m g:test_team:r-x project_workspace/source_code
sudo setfacl -d -m g:dev_team:rwx project_workspace/source_code
sudo setfacl -d -m g:test_team:r-x project_workspace/source_code

#for build-Everyone can read and execute, but only admins can modify
sudo setfacl -m g:everyone:r-x project_workspace/builds
sudo setfacl -m g:admins:rwx project_workspace/builds
sudo setfacl -d -m g:everyone:r-x project_workspace/builds
sudo setfacl -d -m g:admins:rwx project_workspace/builds

#for logs-Only admins can write, others can read
sudo setfacl -m g:everyone:r-x project_workspace/logs
sudo setfacl -m g:admins:rwx project_workspace/logs
sudo setfacl -d -m g:everyone:r-x project_workspace/logs
sudo setfacl -d -m g:admins:rwx project_workspace/logs

#for backup- Only backup team can write, everyone else can read
sudo setfacl -m g:everyone:r-x project_workspace/backups
sudo setfacl -m g:backup_team:rwx project_workspace/backups
sudo setfacl -d -m g:everyone:r-x project_workspace/backups
sudo setfacl -d -m g:backup_team:rwx project_workspace/backups

#for shared-Everyone can read/write
sudo setfacl -m g:everyone:rwx project_workspace/shared
sudo setfacl -d -m g:everyone:rwx project_workspace/shared
