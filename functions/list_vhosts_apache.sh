#!/bin/bash

# Check which command exists
apachectl -S >/dev/null 2>&1
if [ $? -eq 0 ]; then
  apachectl -S 2>/dev/null | grep namevhost | awk '{print $4}'
else
  apache2ctl -S 2>/dev/null | grep namevhost | awk '{print $4}'
fi

