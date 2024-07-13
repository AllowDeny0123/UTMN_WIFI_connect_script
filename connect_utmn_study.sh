#!/bin/bash

wlan_adapter=$(nmcli device | grep wifi\ | awk '{print $1}'
)
connect_to_wifi () {
	sudo wpa_supplicant -i $wlan_adapter -c $1 > /dev/null &
}

on_interrupt () {
	echo "Exiting..."
	sudo pkill wpa_supplicant
	sudo systemctl start NetworkManager
	echo "Exit completed!"
	exit
}

trap on_interrupt INT
echo "Exiting Network Manager..."
sudo systemctl stop NetworkManager
echo "Connecting to network..."
connect_to_wifi $1
echo "DHCP'ing IP address..."
sudo dhclient $wifi_adapter

while true; do
	sleep 1
done
