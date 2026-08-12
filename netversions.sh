#!/usr/bin/env bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

export PATH=$PATH:/sbin:/usr/sbin
lshwcmd=`which lshw`
lspcicmd=`which lspci`
modinfocmd=`which modinfo`
for pciaddress in $(${lshwcmd} -C Network 2>/dev/null | grep "pci@" | awk -F":" '{print $3":"$4}');
do
    pcioutput=$("$lspcicmd" -v -s "$pciaddress")
    kernel_driver=$(echo "$pcioutput" | grep "Kernel driver" | awk '{print $NF}')
    kernel_modules=$(echo "$pcioutput" | grep "Kernel modules" | awk '{print $NF}')
    if [ -n "$kernel_driver" ]; then
        kernel_info=$kernel_driver
    else
        kernel_info=$kernel_modules
    fi
    version=$(${modinfocmd} $kernel_info 2>/dev/null | grep ^version: | head -n1 | awk '{print $2}' | xargs)
    vermagic=$(${modinfocmd} $kernel_info 2>/dev/null | grep ^vermagic: | awk '{print $2}' | xargs)
    if [ -n "${version}" ]; then
        echo $version
    else
        echo $vermagic
    fi
done
# support for QLogic and Emulex HBA Adapter
${lspcicmd} -nn | grep -Ei 'hba|host bus adapter|fibre channel' | awk -F" " '{print $1}' | while read pciaddress;
do
    hbaoutput=$("$lspcicmd" -v -s "$pciaddress")
    hba_kernel_driver=$(echo "$hbaoutput" | grep "Kernel driver" | awk '{print $NF}')
    hba_kernel_modules=$(echo "$hbaoutput" | grep "Kernel modules" | awk '{print $NF}')
    if [ -n "$hba_kernel_driver" ]; then
        hba_kernel_info=$hba_kernel_driver
    else
        hba_kernel_info=$hba_kernel_modules
    fi
    hbaversionstring=$(${modinfocmd} $hba_kernel_info 2>/dev/null | grep ^version: | head -n1 | awk '{print $2}' | xargs)
    hbavermagic=$(${modinfocmd} $hba_kernel_info 2>/dev/null | grep ^vermagic: | awk '{print $2}' | xargs)
    if [ -n "${hbaversionstring}" ]; then
        echo $hbaversionstring
    else
        echo $hbavermagic
    fi
done
