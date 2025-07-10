#!/bin/bash
# Copyright (c) 2025 Cisco Systems, Inc. All rights reserved.

export PATH=$PATH:/sbin:/usr/sbin
installationPath="/opt/os-discovery-tool"
ucsToolVersion=""

cleanup_host-inv()
{
	#Remove old host-inv.yaml off local system
	[ -e $filename ] && rm $filename
}

write-osinfo()
{
	#Start creating host-inv.yaml on local system
	echo "annotations:" > $filename

	kernel_version=$(uname -r | awk '{print $1}')
	os_type=$(uname -s | awk '{print $1}')
	os_arch=$(uname -m | awk '{print $1}')
	os_vendor=$($installationPath/osvendor.sh)


	if [[ $os_vendor == 'ubuntu' ]]
	then
	  os_name=$($installationPath/debian-os-name.sh)
	  os_flavor=$($installationPath/debian-os-version.sh)
	  os_vendor='Ubuntu'
	elif [[ $os_vendor == 'rhel' ]]
	then
	  os_name=$($installationPath/redhat-os-name.sh)
	  os_flavor=$($installationPath/redhat-os-name.sh)
	  os_vendor='Red Hat'
	elif [[ $os_vendor == 'rhcos' ]]
	then
	  os_name=$($installationPath/coreos-name.sh)
	  os_flavor=$($installationPath/coreos-name.sh)
	  os_vendor='Red Hat'
	elif [[ $os_vendor == 'rocky' ]]
	then
	  os_name=$($installationPath/rocky-os-name.sh)
	  os_flavor=$($installationPath/rocky-os-name.sh)
	  os_vendor='Rocky Linux'
	elif [[ $os_vendor == 'ol' ]]
	then
	  os_name=$($installationPath/oracle-os-name.sh)
	  os_flavor=$($installationPath/oracle-os-version.sh)
	  os_vendor='Oracle'
    elif [[ $os_vendor == 'sles' ]]
    then
      os_name=$($installationPath/suse-os-version.sh)
      os_flavor=$($installationPath/suse-os-version.sh)
      os_vendor='SuSE'
	else
	  echo "Currently Unsupported OS"
	fi

	updateTimestamp=$(date -Is)

	releaseVersionString=$kernel_version
	type=$os_type
	vendor=$os_vendor
	name=$os_name
	arch=$os_arch

	echo " -kv:" >> $filename
	echo "  key: os.ucsToolVersion" >> $filename
	echo "  value:" $ucsToolVersion >> $filename

	echo " -kv:" >> $filename
	echo "  key: os.updateTimestamp" >> $filename
	echo "  value:" $updateTimestamp >> $filename

	echo " -kv:" >> $filename
	echo "  key: os.kernelVersionString" >> $filename
	echo "  value:" $os_flavor >> $filename

	echo " -kv:" >> $filename
	echo "  key: os.releaseVersionString" >> $filename
	echo "  value:" $releaseVersionString >> $filename

	echo " -kv:" >> $filename
	echo "  key: os.type" >> $filename
	echo "  value:" $os_type >> $filename

	echo " -kv:" >> $filename
	echo "  key: os.vendor" >> $filename
	echo "  value:" $os_vendor >> $filename

	echo " -kv:" >> $filename
	echo "  key: os.name" >> $filename
	echo "  value:" $os_name >> $filename

	echo " -kv:" >> $filename
	echo "  key: os.arch" >> $filename
	echo "  value:" $os_arch >> $filename
}

write-networkinfo()
{
	echo "Getting Network Driver Info"

	drivers=$($installationPath/netdriver.sh)
	versions=$($installationPath/netversions.sh)
	description=$($installationPath/netdev.sh)

	totaldrivercount=0

	counter=0
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.name" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
		((totaldrivercount++))
	done <<< "$drivers"

	counter=0
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.version" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
	done <<< "$versions"

	counter=0
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.description" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
	done <<< "$description"
}

write-fcinfo()
{
	echo "Getting vHBA Driver Info"

	fc_dev=$($installationPath/fcdev.sh)
	drivers=$($installationPath/fcdriver.sh)
	versions=$($installationPath/fcversions.sh)

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.name" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
	done <<< "$drivers"

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.version" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
	done <<< "$versions"

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.description" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
		((totaldrivercount++))
	done <<< "$fc_dev"
}

write-storageinfo()
{
	echo "Getting Storage Driver Info"

	drivers=$($installationPath/storagedriver.sh)
	versions=$($installationPath/storageversions.sh)
	description=$($installationPath/storagedev.sh)

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.name" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
	done <<< "$drivers"

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.version" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
	done <<< "$versions"

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.description" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
		((totaldrivercount++))
	done <<< "$description"
}

write-gpuinfo()
{
	echo "Getting GPU Info"

	drivers=$($installationPath/gpudriver.sh)
	if [[ -z $drivers ]]; then
	  return
	fi
	versions=$($installationPath/gpuversions.sh)
	description=$($installationPath/gpudev.sh)

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.name" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
	done <<< "$drivers"

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.version" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
	done <<< "$versions"

	counter=$totaldrivercount
	while IFS= read -r line; do
		echo " -kv:" >> $filename
		echo "  key: os.driver.$counter.description" >> $filename
		echo "  value:" $line >> $filename
		((counter++))
		((totaldrivercount++))
	done <<< "$description"
}

write-endkeyinfo()
{
	echo " -kv:" >> $filename
	echo "  key: os.InvEndKey" >> $filename
	echo "  value: InvEndValue" >> $filename
}

filename=$installationPath/"host-inv.yaml"

cleanup_host-inv
write-osinfo
if ! $(command -v modinfo &> /dev/null) || ! $(command -v lspci &> /dev/null) || ! $(command -v lshw &> /dev/null)
    then
        echo "INFO - Tools validation failed!  Make sure host has lshw(RHEL/Ubuntu/Centos)/hwinfo(SLES), pci-utils(lspci) and modinfo installed and available"
        echo "INFO - Only the operating system information will be collected and sent to Intersight. However, the adapter information will not be available due to missing tools"
    else
        write-networkinfo
        write-fcinfo
        write-storageinfo
        write-gpuinfo
fi
write-endkeyinfo

#Send host-inv.yaml file to IMC
$installationPath/send_inventory_to_imc.sh
