#!/bin/bash
# Check if there is a running nginx instance
ps aux|grep nginx|grep -v grep > /dev/null
if [ $? -eq 0 ]; then
  echo -n "yes"
else
  echo -n "no"
fi
