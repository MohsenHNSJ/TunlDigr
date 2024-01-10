#!/bin/bash

scriptVersion="0.1.3"

askTunnelingMethod() {
	# We ask the user to select the desired tunneling method
	# We limit the input character count to 1 by using (-n) argument
	echo -e "1 - Hysteria 2\n2 - Reality (XTLS VLESS)\n3 - Shadowsocks (Obsolete)"

	read -n 1 -p "Select tunneling method: " tunnelingMethod

	# We validate user input
	until [[ $tunnelingMethod == +([1-3]) ]]; do
		echo
		read -n 1 -p "Invalid input, please only input a number from 1 - 3: " tunnelingMethod
	done
}

installPackages() {
	echo -e "=========================================================================\n|       Updating repositories and installing the required packages      |\n|              (This may take a few minutes, Please wait...)            |\n========================================================================="
	# We update 'apt' repository 
	# We install/update the packages we use during the process to ensure optimal performance
	# This installation must run without confirmation (-y)
	sudo apt update
	sudo apt -y install wget tar openssl gawk sshpass ufw coreutils curl adduser sed grep util-linux qrencode unzip snapd haveged
}

installHysteria() {

	echo "\ninstalling Hysteria"
	# We check and save the latest version number of Sing-Box
	# latestsingboxversion="$(curl --silent "https://api.github.com/repos/SagerNet/sing-box/releases/latest" | grep -Po "(?<=\"tag_name\": \").*(?=\")"  | sed 's/^.//' )"
}

installReality() {
	echo "installing Reality"
}

installShadowSocks() {
	echo "installing Shadowsocks"
}

# We get provided arguments
i=1;
totalArguments=$#

# We iterate all arguments
while [ $i -le $totalArguments ]
do 
	i=$((i + 1));
	# We check for tunneling method argument
	if  [ $1 = "-tm" ]; then
		shift
		# Hysteria 2
		if [ $1 == "h2" ]; then
			tunnelingMethod=1
		fi
		# Reality
		if [ $1 == "xr" ]; then
			tunnelingMethod=2
		fi
		# Shadowsocks
		elif [ $1 == "ss" ]; then
			tunnelingMethod=3	
		# Invalid input
		else 
			echo "Invalid input for argument -tm. ignoring"	
		fi
done

echo "=========================================================================
|                    TunlDigr by @MohsenHNSJ (Github)                   |
=========================================================================
Check out the github page, contribute and suggest ideas/bugs/improvments.

==========================
| Script version $scriptVersion   |
=========================="

# We check wether the method is supplied at execution or not
# if not, we ask the user by calling the askTunnelingMethod function
if [ ! -v tunnelingMethod ]; then
	askTunnelingMethod
fi

#installPackages

case $tunnelingMethod in
	1)
	installHysteria
	;;
	2)
	installReality
	;;
	3)
	installShadowSocks
	;;
esac