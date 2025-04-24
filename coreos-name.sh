#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

version=`cat /etc/*-release | grep 'VERSION_ID\=' | head -n1 | awk -F'=' '{print $2}'| awk -F'"' '{print $2}'`
echo "Red Hat Enterprise Linux CoreOS "$version