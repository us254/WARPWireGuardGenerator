#!/bin/sh

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

red() {
	echo -e "\033[31m\033[01m$1\033[0m"
}

green() {
	echo -e "\033[32m\033[01m$1\033[0m"
}

yellow() {
	echo -e "\033[33m\033[01m$1\033[0m"
}

rm -f warp.conf proxy.conf

chmod +x ./warp-go ./warp-api
clear
yellow "Black and white information heibai.pro"
yellow "Black and white video youtube.com/@heibaipro"
yellow "Please select the WARP account type you want to use"
echo ""
echo -e " ${GREEN}1.${PLAIN} WARP Free Account ${YELLOW}(Default)${PLAIN}"
echo -e " ${GREEN}2.${PLAIN} WARP+"
echo -e " ${GREEN}3.${PLAIN} WARP Teams"
echo ""
read -p "Please enter options [1-3]: " account_type
if [[ $account_type == 2 ]]; then
	yellow "How to obtain CloudFlare WARP account key information: "
	green "PC: Download and install CloudFlare WARP → Settings → Preferences → Accounts → Copy the key into the script"
	green "Mobile: Download and install 1.1.1.1 APP → Menu → Account → Copy the key into the script"
	echo ""
	yellow "Important: Please ensure that the account status of the 1.1.1.1 APP on your mobile phone or computer is WARP+!"
	echo ""
	read -rp "Enter WARP account license key (26 characters): " warpkey
	until [[ $warpkey =~ ^[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}-[A-Z0-9a-z]{8}$ ]]; do
		red "WARP account license key format input error, please re-enter!"
		read -rp "Enter WARP account license key (26 characters): " warpkey
	done
	read -rp "Please enter a custom device name. If not entered, the default random device name will be used: " device_name
	[[ -z $device_name ]] && device_name=$(date +%s%N | md5sum | cut -c 1-6)

	result_output=$(./warp-api)

	device_id=$(echo "$result_output" | awk -F ': ' '/device_id/{print $2}')
	private_key=$(echo "$result_output" | awk -F ': ' '/private_key/{print $2}')
	warp_token=$(echo "$result_output" | awk -F ': ' '/token/{print $2}')

	cat <<EOF >warp.conf
[Account]
Device = $device_id
PrivateKey = $private_key
Token = $warp_token
Type = free
Name=WARP
MTU = 1280

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
Endpoint = 162.159.192.8:0
Endpoint6 = [2606:4700:d0::a29f:c008]:0
# AllowedIPs = 0.0.0.0/0
# AllowedIPs = ::/0
KeepAlive=30
EOF

	./warp-go --update --config=./warp.conf --license=$warpkey --device-name=$device_name
elif [[ $account_type == 3 ]]; then
	yellow "Please get your WARP Teams account TOKEN from this website: https://web--public--warp-team-api--coia-mfs4.code.run/"
	read -rp "Please enter the TOKEN of your WARP Teams account:" teams_token
	if [[ -n $teams_token ]]; then
		read -rp "Please enter a custom device name. If not entered, the default random device name will be used: " device_name
		[[ -z $device_name ]] && device_name=$(date +%s%N | md5sum | cut -c 1-6)

		result_output=$(./warp-api)

		device_id=$(echo "$result_output" | awk -F ': ' '/device_id/{print $2}')
		private_key=$(echo "$result_output" | awk -F ': ' '/private_key/{print $2}')
		warp_token=$(echo "$result_output" | awk -F ': ' '/token/{print $2}')

		cat <<EOF >warp.conf
[Account]
Device = $device_id
PrivateKey = $private_key
Token = $warp_token
Type = free
Name=WARP
MTU = 1280

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
Endpoint = 162.159.192.8:0
Endpoint6 = [2606:4700:d0::a29f:c008]:0
# AllowedIPs = 0.0.0.0/0
# AllowedIPs = ::/0
KeepAlive=30
EOF

		./warp-go --update --config=warp.conf --team-config=$teams_token --device-name=$device_name

		sed -i "s/Type =.*/Type = team/g" warp.conf
	else
		red "The WARP Teams account TOKEN was not entered, the script exited!"
		exit 1
	fi
else
	result_output=$(./warp-api)

	device_id=$(echo "$result_output" | awk -F ': ' '/device_id/{print $2}')
	private_key=$(echo "$result_output" | awk -F ': ' '/private_key/{print $2}')
	warp_token=$(echo "$result_output" | awk -F ': ' '/token/{print $2}')

	cat <<EOF >warp.conf
[Account]
Device = $device_id
PrivateKey = $private_key
Token = $warp_token
Type = free
Name=WARP
MTU = 1280

[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
Endpoint = 162.159.192.8:0
Endpoint6 = [2606:4700:d0::a29f:c008]:0
# AllowedIPs = 0.0.0.0/0
# AllowedIPs = ::/0
KeepAlive=30
EOF
fi

./warp-go --config=warp.conf --export-wireguard=proxy.conf

clear
green "WARP-GO's WireGuard configuration file has been generated successfully!"
yellow "The following is the configuration file content:"
red "$(cat proxy.conf)"
echo ""
yellow "The following is the configuration file sharing QR code:"
qrencode -t ansiutf8 <proxy.conf
echo ""
yellow "Please use this method locally: https://blog.misaka.rest/2023/03/12/cf-warp-yxip/ Prefer the available Endpoint IP"
