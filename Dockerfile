FROM redhat/ubi8

# Register with the entitlement server
# This example uses placeholders for username and password
RUN subscription-manager register --username <your_username> --password <your_password>

# Update the package list
RUN yum update -y && \
    yum install -y kmod lshw pciutils sudo ipmitool cronie && \
    yum clean all

# Unregister with the entitlement server
RUN subscription-manager unregister

# Create application directory
RUN mkdir -p /opt/ucs-tool

# Copy ODT files
COPY ./LICENSE ./debian-os-name.sh ./debian-os-version.sh ./fcdev.sh ./fcdriver.sh ./fcversions.sh ./gather_inventory_from_host.sh ./gpudev.sh ./gpudriver.sh ./gpuversions.sh ./host-inv.yaml ./netdev.sh ./netdriver.sh ./netversions.sh ./oracle-os-name.sh ./oracle-os-version.sh ./osvendor-legacy.sh ./osvendor.sh ./redhat-os-name.sh ./rocky-os-name.sh ./send_inventory_to_imc.sh ./storagedev.sh ./storagedriver.sh ./storageversions.sh ./suse-os-version.sh ./coreos-name.sh /opt/ucs-tool/

WORKDIR /opt/ucs-tool

# Create cron job configuration
RUN echo "#Schedule the os inventory to imc:" >> /opt/ucs-tool/odtcron
RUN echo "0 0 * * * /opt/ucs-tool/gather_inventory_from_host.sh & > /var/log/mycron.log 2>&1" >> /opt/ucs-tool/odtcron
RUN echo "@reboot /opt/ucs-tool/gather_inventory_from_host.sh & > /var/log/mycron.log 2>&1" >> /opt/ucs-tool/odtcron
RUN crontab /opt/ucs-tool/odtcron

CMD ["crond", "-n"]