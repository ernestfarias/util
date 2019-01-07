#Change Static IP address and restart networking service
#set interface name and iface frendly name
#Author: Ernest A Farias - 2019
#
#! /bin/bash
#set -x

#guess the management port

IFACENAME=""
IFACEFRIENDLYNAME="Management NIC Port"
IFACESFILE=/etc/network/interfaces2

##GUESS or decide IFNAME if p4p1 or em4 ifaces are in interfaces files assume it is the mgmt iface
##if none of those names, user must enter iface name on input
echo "This script allows to change the IP address to static or dynamic"
if [[ $(grep "auto p4p1" ${IFACESFILE}) ]]
then
 IFACENAME=p4p1
else
    if [[ $(grep "auto em4" ${IFACESFILE}) ]]
	then
        IFACENAME=em4
	fi
fi


if [[ "" == ${IFACENAME} ]]
	then
    echo "Please enter $IFACEFRIENDLYNAME Interface Name and press [ENTER]: p4p1,em4 or as indicated by the sysadmin"
    read IFACENAME
#    IFACENAME=IFACENAMEIN
else
    echo "Please enter $IFACEFRIENDLYNAME Interface Name and press [ENTER] to default: ${IFACENAME}"
    read pp
fi
####

#decide static or dynamic
echo -e "Select configuration:\n 1: Static IP Address\n 2: Dynamic IP Address(DHCP)"
read  -p ":" prompt
if [[ $prompt == "2" ]]
then #Dyn Config
	echo "Dynamic config..."

echo "removing previous and old iface config"
sed '/internet interface/,+3 d' $IFACESFILE  > ./tmp.pp
cat ./tmp.pp  > $IFACESFILE
sed '/Config by eaf cmd script/,+7 d' $IFACESFILE  > ./tmp.pp
cat ./tmp.pp  > $IFACESFILE
# cleanup existing file
#REMOVES ALL LINES WHERE IFACENAME EXIST
#echo "# This file describes the network interfaces available on your system." >> /etc/network/interfaces

echo "# ${IFACEFRIENDLYNAME} Config by eaf cmd script" >> $IFACESFILE
echo "auto $IFACENAME" >> $IFACESFILE
echo "allow-hotplug $IFACENAME" >> $IFACESFILE
echo "iface $IFACENAME inet dhcp" >> $IFACESFILE
echo "# do not remove" >> $IFACESFILE
echo "# do not remove" >> $IFACESFILE
echo "# do not remove" >> $IFACESFILE
echo "# do not remove" >> $IFACESFILE
echo ""

	else #static config
	echo "Static config..."
echo "Configuring $IFACEFRIENDLYNAME($IFACENAME)..."
echo "Please enter IP Address for $IFACENAME and press [ENTER]: ie.'192.168.3.3'"
read ip_address
echo "Please enter Gateway for $IFACENAME and press [ENTER]: ie.'192.168.3.1'"
read gateway
echo "Please enter a Subnet Mask for $IFACENAME and press [ENTER]: ie.'255.255.255.0'"
read subnet_mask
echo "Please enter the DNS Servers for $IFACENAME and press [ENTER]: space separated values if many, ie. '8.8.8.8 192.168.3.1' "
read dns_servers
echo "These are the values you entered for $IFACENAME:"
echo -e " IP Address: $ip_address\n Gateway: $gateway\n Mask: $subnet_mask\n DNS Server(s): $dns_servers"
echo "[ENTER] to continue..."
read pp

echo "removing previous iface and old config"
sed '/internet interface/,+3 d' $IFACESFILE  > ./tmp.pp
cat ./tmp.pp  > $IFACESFILE
sed '/Config by eaf cmd script/,+7 d' $IFACESFILE  > ./tmp.pp
cat ./tmp.pp  > $IFACESFILE

# cleanup existing file
#REMOVES ALL LINES WHERE IFACENAME EXIST
#echo "# This file describes the network interfaces available on your system." >> /etc/network/interfaces

echo "# ${IFACEFRIENDLYNAME} Config by eaf cmd script" >> $IFACESFILE
echo "auto $IFACENAME" >> $IFACESFILE
echo "allow-hotplug $IFACENAME" >> $IFACESFILE
echo "iface $IFACENAME inet static" >> $IFACESFILE
echo "address $ip_address" >> $IFACESFILE
echo "gateway $gateway" >> $IFACESFILE
echo "netmask $subnet_mask" >> $IFACESFILE
echo "dns-nameservers $dns_servers" >> $IFACESFILE
echo ""

fi
######

# Restart networking...
#/etc/init.d/networking restart
/bin/systemctl restart networking

# All Done...
echo "Interface are setup as follows..."
ip address show dev $IFACENAME
