#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

cat /etc/*-release 2>/dev/null | grep -i ^ID= | head -n1 | awk -F"=" '{print $2}'| xargs
