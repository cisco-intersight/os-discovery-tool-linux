#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

redhat_version=$(cat /etc/*-release | grep ^VERSION | head -n1 | awk -F"=" '{print $2}' | xargs | awk -F'[ ]' '{print $1}' | xargs)
min_version=8.0
if [[ "$(echo -e "$redhat_version\n$min_version" | sort -V | head -n1)" == "$min_version" ]];
  then
  echo $(cat /etc/redhat-release 2>/dev/null | awk '{print $1" "$2" "$3" "$4" "$6}')
else
  echo $(cat /etc/redhat-release 2>/dev/null | awk '{print $1" "$2" "$3" "$4" "$7}')
fi
