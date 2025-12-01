#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

export PATH=$PATH:/sbin:/usr/sbin
ipmitoolcmd=`which ipmitool 2>/dev/null`
if [ $? -ne 0 ]; then
    echo "Error: ipmitool not found."
    exit 1
fi
installationPath="/opt/ucs-tool"
inventoryfilename=$installationPath/"host-inv.yaml"
netfunction="0x36"
descriptorpart="1"
servermodel=`/usr/sbin/dmidecode -s system-product-name`
if [[ $servermodel == *"CAI-845A"* ]]; then
    netfunction="0x34"
    descriptorpart="4"
elif [[ $servermodel == *"UCSC-885A"* ]]; then
    netfunction="0x30"
    descriptorpart="4"
fi

removeInventory(){
    echo "[localhost]: Removing existing inventory file from IMC"
    cmd="${ipmitoolcmd} raw ${netfunction} 0x77 0x03 0x68 0x6f 0x73 0x74 0x2d 0x69 0x6e 0x76 0x2e 0x79 0x61 0x6d 0x6c"
    $cmd >/dev/null 2>&1
}

createInventory(){
    filedescriptor=$(${ipmitoolcmd} raw ${netfunction} 0x77 0x00 0x68 0x6f 0x73 0x74 0x2d 0x69 0x6e 0x76 0x2e 0x79 0x61 0x6d 0x6c)
    filedescriptor="0x${filedescriptor:$descriptorpart}"

    filebytearray=($(od -An -vtx1 $inventoryfilename | tr -d '\n'))

    payload=""
    counter=0
    payloadlength="0x28"
    filelocationpointer=0

    echo "[localhost]: Writing inventory file to IMC"

    for (( i=0; i<${#filebytearray[@]}; i++ )); do
        b=${filebytearray[$i]}
        ((counter++))
        if [ $counter -le 39 ]; then
            payload+=$(printf '0x%s ' "$b")
        else
            payload+=$(printf '0x%s ' "$b")
            filepointer=$(printf "0x%04X" $filelocationpointer)
            filepointer=$(echo $filepointer | sed -E 's/0x(..)(..)/0x\2 0x\1/')
            cmd="${ipmitoolcmd} raw ${netfunction} 0x77 0x02 "$filedescriptor" "$payloadlength" "$filepointer" 0x00 0x00 "$payload
            filelocationpointer=$((filelocationpointer+40))
            $cmd >/dev/null 2>&1
            counter=0
            payload=""
        fi
    done

    filepointer=$(printf "0x%04X" $filelocationpointer)
    filepointer=$(echo $filepointer | sed -E 's/0x(..)(..)/0x\2 0x\1/')
    cmd="${ipmitoolcmd} raw ${netfunction} 0x77 0x02 "$filedescriptor" "$(printf '0x%x\n' $counter)" "$filepointer" 0x00 0x00 "$payload
    $cmd >/dev/null 2>&1

    cmd="${ipmitoolcmd} raw ${netfunction} 0x77 0x01 "$filedescriptor
    $cmd >/dev/null 2>&1
}

# Execute based on command line argument
if [ "$1" = "--removeInventory" ]; then
    removeInventory
    echo "[localhost]: Inventory removed from IMC!"
else
    removeInventory
    createInventory
    echo "[localhost]: Done!"
fi
