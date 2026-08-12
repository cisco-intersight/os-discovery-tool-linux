#!/usr/bin/env bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

export PATH=$PATH:/sbin:/usr/sbin
lshwcmd=`which lshw`
lspcicmd=`which lspci`
for pciaddress in $(${lshwcmd} -C Network 2>/dev/null | grep "pci@" | awk -F":" '{print $3":"$4}');
do
    pcioutput=$("$lspcicmd" -v -s "$pciaddress")
    kernel_driver=$(echo "$pcioutput" | grep "Kernel driver" | awk '{print $NF}')
    kernel_modules=$(echo "$pcioutput" | grep "Kernel modules" | awk '{print $NF}')
    if [ -n "$kernel_driver" ]; then
        echo $kernel_driver
    else
        echo $kernel_modules
    fi
done
# support for QLogic and Emulex HBA Adapter
${lspcicmd} -nn | grep -Ei 'hba|host bus adapter|fibre channel' | awk -F" " '{print $1}' | while read pciaddress;
do
    hbaoutput=$("$lspcicmd" -v -s "$pciaddress")
    hba_kernel_driver=$(echo "$hbaoutput" | grep "Kernel driver" | awk '{print $NF}')
    hba_kernel_modules=$(echo "$hbaoutput" | grep "Kernel modules" | awk '{print $NF}')
    if [ -n "$hba_kernel_driver" ]; then
        echo $hba_kernel_driver
    else
        echo $hba_kernel_modules
    fi
done
