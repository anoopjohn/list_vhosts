#!/bin/bash

hosts_file="hosts.txt"

function run_script() {
  user_at_host="$1"
  script_name="$2"
  ssh -o BatchMode=yes -o PubkeyAuthentication=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$user_at_host" 'bash -s' < "$script_name"  
}

# Ref: Return values from a function
# https://www.linuxjournal.com/content/return-values-bash-functions

# Check if the user can login to the server
function can_login() {
  user_at_host="$1"
  ret=`run_script "$user_at_host" "functions/can_login.sh"`
  regexp='^[0-9]+$'
  if ! [[ $ret =~ $regexp ]] ; then
    # Not a number, was not able to login
    return 1
  else
    # Is a number, was able to login
    return 0
  fi
}

# Check if there is nginx running on the server
function has_nginx() {
  user_at_host="$1"
  ret=`run_script "$user_at_host" "functions/has_nginx.sh"`
  #echo ":$ret:"
  if [[ "$ret" == "yes" ]]; then
    return 0
  else
    return 1
  fi
}

# Check if there is apache running on the server
function has_apache() {
  user_at_host="$1"
  ret=`run_script "$user_at_host" "functions/has_apache.sh"`
  #echo ":$ret:"
  if [[ "$ret" == "yes" ]]; then
    return 0
  else
    return 1
  fi
}

# List nginx vhosts in the server
function list_vhosts_nginx() {
  user_at_host="$1"
  ret=`run_script "$user_at_host" "functions/list_vhosts_nginx.sh"`
  echo "$ret"
}

# List apache vhosts in the server
function list_vhosts_apache() {
  user_at_host="$1"
  ret=`run_script "$user_at_host" "functions/list_vhosts_apache.sh"`
  echo "$ret"
}

# Loop through lines in the hosts file
while read user_at_host; do 
  echo "==============================================================="
  echo "$user_at_host"
  echo "Logging in to $user_at_host"
  echo "Checking connection"
  # Check if the user is able to login to the server
  can_login "$user_at_host"
  if [ $? -eq 0 ]; then
    echo "Connecting to server successful"
  else
    echo "Unable to connect to server"
    echo "$user_at_host" >> logs/failed_login.log
    # Continue to the next server in the list
    continue
  fi
  # Connection has been verified at this point
  # Check if the server has nginx
  has_nginx "$user_at_host"
  if [ $? -eq 0 ]; then
    echo "Server has nginx running on it"
    echo "$user_at_host" >> logs/nginx_servers.log
    list_vhosts_nginx "$user_at_host"
  else
    echo "There is no nginx instance running"
  fi
  # Check if the server has apache
  has_apache "$user_at_host"
  if [ $? -eq 0 ]; then
    echo "Server has apache running on it"
    echo "$user_at_host" >> logs/apache_servers.log
    list_vhosts_apache "$user_at_host"
  else
    echo "There is no apache instance running"
  fi
done < "$hosts_file"

