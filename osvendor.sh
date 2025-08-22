#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

releasefile="/etc/*-release"
osid=$(cat $releasefile 2>/dev/null | grep -i ^ID= | head -n1 | awk -F"=" '{print $2}'| xargs)
osvariant=$(cat $releasefile 2>/dev/null | grep -i ^VARIANT_ID= | head -n1 | awk -F"=" '{print $2}'| xargs)
if [[ ( $osid = "rhel" || $osid = "rhcos" ) && $osvariant = "coreos" ]]; then
    # till coreos 4.18, id value was "rhcos" and then it got changed to "rhel" and variant to "coreos" and hence this condition included to support both
    echo "rhcos"
else
    echo $osid
fi
