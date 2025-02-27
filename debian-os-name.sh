#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

cat /etc/*-release | grep 'PRETTY_NAME\=' | head -n1 | awk -F"=" '{print $2}' | xargs | awk '{print $1" "$2" "$3}'
