#!/bin/bash
if [[ -d /etc/nginx/sites-enabled/ ]]; then
  grep server_name /etc/nginx/sites-enabled/* | awk '{print $3}'
fi
if [[ -d /opt/nginx/conf/ ]]; then
  grep server_name /opt/nginx/conf/* | awk '{print $3}'
fi
# Find nginx folder
nginx_path=`ps -waux|grep nginx | grep "master process" | sed 's/.*\s*-p\s*//' | sed 's/\s.*//'`
if [[ -d "$nginx_path" ]]; then
  grep -r server_name "$nginx_path" | awk '{print $3}'
fi