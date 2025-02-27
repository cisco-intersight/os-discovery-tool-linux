#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

cat /etc/*-release | grep "Linux" | head -n 1 | awk '{print $1" "$2}'
