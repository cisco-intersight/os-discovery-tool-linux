#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

cat /etc/*-release | grep PRETTY_NAME | awk -F"=" '{print $2}' | xargs