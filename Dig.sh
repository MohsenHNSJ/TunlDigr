#!/bin/bash

askTunnelingMethod() {
	# We ask the user to select the desired tunneling method
	# We limit the input character count to 1 by using (-n) argument
	echo "1 - Hysteria 2
	2 - Reality (XTLS VLESS)
	3 - Shadowsocks (Obsolete)"
	read -n 1 -p "Select tunneling method: " tunnelingMethod

	# We validate user input
	until [[ $tunnelingMethod == +([1-3]) ]]; do
		echo
		read -n 1 -p "Wrong input, please only input a number from 1 - 3: " tunnelingMethod
	done
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
		fi
done

scriptVersion="0.1.1"

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

echo "=========================================================================
|       Updating repositories and installing the required packages      |
|              (This may take a few minutes, Please wait...)            |
========================================================================="
# We update 'apt' repository 
# We install/update the packages we use during the process to ensure optimal performance
# This installation must run without confirmation (-y)
sudo apt update
sudo apt -y install wget tar openssl gawk sshpass ufw coreutils curl adduser sed grep util-linux qrencode