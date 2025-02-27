#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

FILE=/etc/rocky-release
if [ -f "$FILE" ]; then
    # from Rocky Linux 9.1 file name changed to rocky-release
    cat $FILE 2>/dev/null | awk '{print $1" "$2" "$4}' | xargs
else
    cat /etc/centos-release 2>/dev/null | awk '{print $1" "$2" "$4}' | xargs
fi