#!/bin/bash
connect_to_wifi () {
	sudo wpa_supplicant -i wlp3s0 -c $1 > /dev/null &
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
sudo dhclient wlp3s0

while true; do
	sleep 1
done
