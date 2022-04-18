#!/bin/bash
# Check if there is a running apache instance
ps aux|grep httpd|grep -v grep > /dev/null
if [ $? -eq 0 ]; then
  echo -n "yes"
else
  # Check if there is apache
  # Check if there is a running apache instance
  ps aux|grep apache|grep -v grep > /dev/null
  if [ $? -eq 0 ]; then
    echo -n "yes"
  else
    echo -n "no"
  fi
fi
