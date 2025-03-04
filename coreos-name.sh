#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

echo $(cat /etc/redhat-release 2>/dev/null | awk '{print $1" "$2" "$3" "$4" "$5" "$7}')