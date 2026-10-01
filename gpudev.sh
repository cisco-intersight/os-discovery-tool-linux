#!/usr/bin/env bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

export PATH=$PATH:/sbin:/usr/sbin
lshwcmd=`which lshw`
lspcicmd=`which lspci`
gpuvendornvidia='nvidia'
gpuvendoramd='amd'
nvidiasmicmd=`which nvidia-smi 2>&1`
amdcmdpath="/opt/rocm/.info/version"
invalid=" |'"

for pciaddress in $(${lshwcmd} -C Display 2>/dev/null | grep "pci@" | awk -F":" '{print $3":"$4}');
do
    displaydevice=$(${lspcicmd} -v -s ${pciaddress} | grep "Subsystem" | awk -F":" '{print $2}'| xargs);
    # NVIDIA Vendor GPU
    if [[ ${displaydevice,,} =~ ${gpuvendornvidia} ]]; then
        if ! ([[ $nvidiasmicmd =~ $invalid || -z "$nvidiasmicmd" ]]); then
            echo $displaydevice
        fi
    # AMD Vendor GPU
    elif [[ ${displaydevice,,} =~ ${gpuvendoramd} ]]; then
        if [ -e $amdcmdpath ]; then
            echo $displaydevice
        fi
    fi
done

# lshw -C Display misses PCI processing accelerators, so scan lspci as well:
# 1. Find each class 1200 processing accelerator, regardless of vendor ID.
# 2. Check whether amdgpu is the driver in use or is listed under Kernel modules.
# 3. Print the device description if either amdgpu line is present.
# A listed module does not necessarily mean amdgpu is the active driver.
${lspcicmd} -nnk | awk '
    function report_device() {
        if (is_accelerator && has_amdgpu)
            print device_name
    }
    /^[^[:space:]]/ {
        report_device()
        is_accelerator = /Processing accelerators \[1200\]:/
        device_name = $0
        sub(/^[^[:space:]]+[[:space:]]+Processing accelerators \[1200\]:[[:space:]]*/, "", device_name)
        has_amdgpu = 0
    }
    /^[[:space:]]+Kernel (driver in use|modules):/ && /(^|[,[:space:]])amdgpu([,[:space:]]|$)/ {
        has_amdgpu = 1
    }
    END { report_device() }
'
