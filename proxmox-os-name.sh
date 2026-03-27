#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

export PATH=$PATH:/sbin:/usr/sbin
proxmoxcmd=`which pveversion`
proxmox_ve=$("$proxmoxcmd" -v | grep proxmox-ve | awk '{print $2}')
echo Proxmox $proxmox_ve