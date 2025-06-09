Name:           os-discovery-tool
Version:        1.0.1
Release:        1%{?dist}
Vendor:         Cisco Systems, Inc.
Summary:        The Cisco Intersight os-discovery-tool is used to collect operating system and driver information for Hardware Compliance Validation.
License:        Apache-2.0
Source0:        %{name}-%{version}.tar.gz
Requires:       bash, ipmitool

%description
The Cisco Intersight os-discovery-tool is used to collect operating system and driver information for Hardware Compliance Validation.

%global debug_package %{nil}

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/opt/os-discovery-tool
install debian-os-name.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/debian-os-name.sh
install debian-os-version.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/debian-os-version.sh
install fcdev.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/fcdev.sh
install fcdriver.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/fcdriver.sh
install fcversions.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/fcversions.sh
install gather_inventory_from_host.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/gather_inventory_from_host.sh
install gpudev.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/gpudev.sh
install gpudriver.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/gpudriver.sh
install gpuversions.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/gpuversions.sh
install netdev.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/netdev.sh
install netdriver.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/netdriver.sh
install netversions.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/netversions.sh
install osvendor-legacy.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/osvendor-legacy.sh
install osvendor.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/osvendor.sh
install redhat-os-name.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/redhat-os-name.sh
install send_inventory_to_imc.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/send_inventory_to_imc.sh
install storagedev.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/storagedev.sh
install storagedriver.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/storagedriver.sh
install storageversions.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/storageversions.sh
install rocky-os-name.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/rocky-os-name.sh
install oracle-os-name.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/oracle-os-name.sh
install oracle-os-version.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/oracle-os-version.sh
install suse-os-version.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/suse-os-version.sh
install host-inv.yaml $RPM_BUILD_ROOT/opt/os-discovery-tool/host-inv.yaml
install LICENSE $RPM_BUILD_ROOT/opt/os-discovery-tool/LICENSE
install README.md $RPM_BUILD_ROOT/opt/os-discovery-tool/README.md
install coreos-name.sh $RPM_BUILD_ROOT/opt/os-discovery-tool/coreos-name.sh

%post
chmod 755 -R /opt/os-discovery-tool
%define tempFile `mktemp`
#store temp file name
TEMP_FILE_NAME=%{tempFile}
CRON_OUT_FILE=`crontab -l > $TEMP_FILE_NAME`
ADD_TO_CRON=`echo "#Schedule the os inventory to imc:" >> $TEMP_FILE_NAME`
ADD_TO_CRON=`echo "0 0 * * * /opt/os-discovery-tool/gather_inventory_from_host.sh & > /dev/null 2>&1 " >> $TEMP_FILE_NAME`
ADD_TO_CRON=`echo "@reboot /opt/os-discovery-tool/gather_inventory_from_host.sh & > /dev/null 2>&1 " >> $TEMP_FILE_NAME`
ADD_TEMP_TO_CRON=`crontab $TEMP_FILE_NAME`
rm -r -f $TEMP_FILE_NAME
#To execute immediately after installation
RUN_CMD=`/opt/os-discovery-tool/gather_inventory_from_host.sh & > /dev/null 2>&1`

%postun
TEMP_FILE_NAME=%{tempFile}
CRON_OUT_FILE=`crontab -l > $TEMP_FILE_NAME`
ADD_TO_CRON=`sed -i '/#Schedule the os inventory to imc:/,+3d' $TEMP_FILE_NAME`
ADD_TO_CRON=`crontab $TEMP_FILE_NAME`
rm -r -f $TEMP_FILE_NAME

%license LICENSE
%files
%dir /opt/os-discovery-tool
%defattr(-,root,root,-)
/opt/os-discovery-tool/debian-os-name.sh
/opt/os-discovery-tool/debian-os-version.sh
/opt/os-discovery-tool/fcdev.sh
/opt/os-discovery-tool/fcdriver.sh
/opt/os-discovery-tool/fcversions.sh
/opt/os-discovery-tool/gather_inventory_from_host.sh
/opt/os-discovery-tool/gpudev.sh
/opt/os-discovery-tool/gpudriver.sh
/opt/os-discovery-tool/gpuversions.sh
/opt/os-discovery-tool/netdev.sh
/opt/os-discovery-tool/netdriver.sh
/opt/os-discovery-tool/netversions.sh
/opt/os-discovery-tool/osvendor-legacy.sh
/opt/os-discovery-tool/osvendor.sh
/opt/os-discovery-tool/redhat-os-name.sh
/opt/os-discovery-tool/send_inventory_to_imc.sh
/opt/os-discovery-tool/storagedev.sh
/opt/os-discovery-tool/storagedriver.sh
/opt/os-discovery-tool/storageversions.sh
/opt/os-discovery-tool/rocky-os-name.sh
/opt/os-discovery-tool/oracle-os-name.sh
/opt/os-discovery-tool/oracle-os-version.sh
/opt/os-discovery-tool/suse-os-version.sh
/opt/os-discovery-tool/host-inv.yaml
/opt/os-discovery-tool/LICENSE
/opt/os-discovery-tool/README.md
/opt/os-discovery-tool/coreos-name.sh
