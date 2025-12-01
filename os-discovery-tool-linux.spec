Name:           ucs-tool
Version:        1.0.1
Release:        1%{?dist}
Vendor:         Cisco Systems, Inc.
Summary:        The Cisco Intersight ucs-tool is used to collect operating system and driver information for Hardware Compliance Validation.
License:        Apache-2.0
Source0:        %{name}-%{version}.tar.gz
Requires:       bash, ipmitool

%description
The Cisco Intersight ucs-tool is used to collect operating system and driver information for Hardware Compliance Validation.

%global debug_package %{nil}

%prep
%setup -q

# Replace the placeholder in gather_inventory_from_host.sh with the actual RPM Version
sed -i "s|@@VERSION@@|%{version}|g" gather_inventory_from_host.sh

%build

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/opt/ucs-tool
install debian-os-name.sh $RPM_BUILD_ROOT/opt/ucs-tool/debian-os-name.sh
install debian-os-version.sh $RPM_BUILD_ROOT/opt/ucs-tool/debian-os-version.sh
install fcdev.sh $RPM_BUILD_ROOT/opt/ucs-tool/fcdev.sh
install fcdriver.sh $RPM_BUILD_ROOT/opt/ucs-tool/fcdriver.sh
install fcversions.sh $RPM_BUILD_ROOT/opt/ucs-tool/fcversions.sh
install gather_inventory_from_host.sh $RPM_BUILD_ROOT/opt/ucs-tool/gather_inventory_from_host.sh
install gpudev.sh $RPM_BUILD_ROOT/opt/ucs-tool/gpudev.sh
install gpudriver.sh $RPM_BUILD_ROOT/opt/ucs-tool/gpudriver.sh
install gpuversions.sh $RPM_BUILD_ROOT/opt/ucs-tool/gpuversions.sh
install netdev.sh $RPM_BUILD_ROOT/opt/ucs-tool/netdev.sh
install netdriver.sh $RPM_BUILD_ROOT/opt/ucs-tool/netdriver.sh
install netversions.sh $RPM_BUILD_ROOT/opt/ucs-tool/netversions.sh
install osvendor-legacy.sh $RPM_BUILD_ROOT/opt/ucs-tool/osvendor-legacy.sh
install osvendor.sh $RPM_BUILD_ROOT/opt/ucs-tool/osvendor.sh
install redhat-os-name.sh $RPM_BUILD_ROOT/opt/ucs-tool/redhat-os-name.sh
install send_inventory_to_imc.sh $RPM_BUILD_ROOT/opt/ucs-tool/send_inventory_to_imc.sh
install storagedev.sh $RPM_BUILD_ROOT/opt/ucs-tool/storagedev.sh
install storagedriver.sh $RPM_BUILD_ROOT/opt/ucs-tool/storagedriver.sh
install storageversions.sh $RPM_BUILD_ROOT/opt/ucs-tool/storageversions.sh
install rocky-os-name.sh $RPM_BUILD_ROOT/opt/ucs-tool/rocky-os-name.sh
install oracle-os-name.sh $RPM_BUILD_ROOT/opt/ucs-tool/oracle-os-name.sh
install oracle-os-version.sh $RPM_BUILD_ROOT/opt/ucs-tool/oracle-os-version.sh
install suse-os-version.sh $RPM_BUILD_ROOT/opt/ucs-tool/suse-os-version.sh
install host-inv.yaml $RPM_BUILD_ROOT/opt/ucs-tool/host-inv.yaml
install LICENSE $RPM_BUILD_ROOT/opt/ucs-tool/LICENSE
install README.md $RPM_BUILD_ROOT/opt/ucs-tool/README.md
install coreos-name.sh $RPM_BUILD_ROOT/opt/ucs-tool/coreos-name.sh

%post
chmod 755 -R /opt/ucs-tool
%define tempFile `mktemp`
#store temp file name
TEMP_FILE_NAME=%{tempFile}
CRON_OUT_FILE=`crontab -l > $TEMP_FILE_NAME`
ADD_TO_CRON=`echo "#Schedule the os inventory to imc:" >> $TEMP_FILE_NAME`
ADD_TO_CRON=`echo "0 0 * * * /opt/ucs-tool/gather_inventory_from_host.sh & > /dev/null 2>&1 " >> $TEMP_FILE_NAME`
ADD_TO_CRON=`echo "@reboot /opt/ucs-tool/gather_inventory_from_host.sh & > /dev/null 2>&1 " >> $TEMP_FILE_NAME`
ADD_TEMP_TO_CRON=`crontab $TEMP_FILE_NAME`
rm -r -f $TEMP_FILE_NAME
#To execute immediately after installation
RUN_CMD=`/opt/ucs-tool/gather_inventory_from_host.sh & > /dev/null 2>&1`

%preun
# Remove inventory from IMC before uninstalling
/opt/ucs-tool/send_inventory_to_imc.sh --removeInventory > /dev/null 2>&1

%postun
TEMP_FILE_NAME=%{tempFile}
CRON_OUT_FILE=`crontab -l > $TEMP_FILE_NAME`
ADD_TO_CRON=`sed -i '/#Schedule the os inventory to imc:/,+3d' $TEMP_FILE_NAME`
ADD_TO_CRON=`crontab $TEMP_FILE_NAME`
rm -r -f $TEMP_FILE_NAME

%license LICENSE
%files
%dir /opt/ucs-tool
%defattr(-,root,root,-)
/opt/ucs-tool/debian-os-name.sh
/opt/ucs-tool/debian-os-version.sh
/opt/ucs-tool/fcdev.sh
/opt/ucs-tool/fcdriver.sh
/opt/ucs-tool/fcversions.sh
/opt/ucs-tool/gather_inventory_from_host.sh
/opt/ucs-tool/gpudev.sh
/opt/ucs-tool/gpudriver.sh
/opt/ucs-tool/gpuversions.sh
/opt/ucs-tool/netdev.sh
/opt/ucs-tool/netdriver.sh
/opt/ucs-tool/netversions.sh
/opt/ucs-tool/osvendor-legacy.sh
/opt/ucs-tool/osvendor.sh
/opt/ucs-tool/redhat-os-name.sh
/opt/ucs-tool/send_inventory_to_imc.sh
/opt/ucs-tool/storagedev.sh
/opt/ucs-tool/storagedriver.sh
/opt/ucs-tool/storageversions.sh
/opt/ucs-tool/rocky-os-name.sh
/opt/ucs-tool/oracle-os-name.sh
/opt/ucs-tool/oracle-os-version.sh
/opt/ucs-tool/suse-os-version.sh
/opt/ucs-tool/host-inv.yaml
/opt/ucs-tool/LICENSE
/opt/ucs-tool/README.md
/opt/ucs-tool/coreos-name.sh
