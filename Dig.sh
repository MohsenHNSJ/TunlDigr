#!/bin/bash

scriptVersion="0.1.5"

askTunnelingMethod() {
	# We ask the user to select the desired tunneling method
	# We limit the input character count to 1 by using (-n) argument
	echo "========================================================================="
	echo "|             Select the desired tunneling method to set up             |"
	echo "|                   Enter only numbers between 1 - 3                    |"
	echo "========================================================================="
	echo "1 - Hysteria 2"
	echo "2 - Reality (XTLS VLESS)"
	echo "3 - Shadowsocks (Obsolete)"

	read -n 1 -p "Select tunneling method: " tunnelingMethod

	# We validate user input
	until [[ $tunnelingMethod == +([1-3]) ]]; do
		echo
		read -n 1 -p "Invalid input, please only input a number from 1 - 3: " tunnelingMethod
	done
}

installPackages() {
	echo "========================================================================="
	echo "|       Updating repositories and installing the required packages      |"
	echo "|              (This may take a few minutes, Please wait...)            |"
	echo "========================================================================="
	# We update 'apt' repository 
	# We install/update the packages we use during the process to ensure optimal performance
	# This installation must run without confirmation (-y)
	sudo apt update
	sudo apt -y install wget tar openssl gawk sshpass ufw coreutils curl adduser sed grep util-linux qrencode unzip snapd haveged
}

showStartupMessage() {
	echo "========================================================================="
	echo "|                    TunlDigr by @MohsenHNSJ (Github)                   |"
	echo "========================================================================="
	echo "Check out the github page, contribute and suggest ideas/bugs/improvments."
	echo
	echo "=========================="
	echo "| Script version $scriptVersion   |"
	echo "=========================="
}

installHysteria() {
	echo
	echo "installing Hysteria 2"

	# We check and save the latest version number of Sing-Box
	latestsingboxversion="$(curl --silent "https://api.github.com/repos/SagerNet/sing-box/releases/latest" | grep -Po "(?<=\"tag_name\": \").*(?=\")"  | sed 's/^.//' )"

	optimizeServerSettings

	addNewUser
}

installReality() {
	echo "installing Reality (XTLS VLESS)"
}

installShadowSocks() {
	echo "installing ShadowSocks"
}

optimizeServerSettings() {
	echo "========================================================================="
	echo "|                       Optimizing server settings                      |"
	echo "========================================================================="
	# We optimise 'sysctl.conf' file for better performance
	sudo echo "net.ipv4.tcp_keepalive_time = 90" >> /etc/sysctl.conf
	sudo echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf
	sudo echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
	sudo echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	sudo echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	sudo echo "fs.file-max = 65535000" >> /etc/sysctl.conf

	# We optimise 'limits.conf' file for better performance
	sudo echo "* soft     nproc          655350" >> /etc/security/limits.conf
	sudo echo "* hard     nproc          655350" >> /etc/security/limits.conf
	sudo echo "* soft     nofile         655350" >> /etc/security/limits.conf
	sudo echo "* hard     nofile         655350" >> /etc/security/limits.conf
	sudo echo "root soft     nproc          655350" >> /etc/security/limits.conf
	sudo echo "root hard     nproc          655350" >> /etc/security/limits.conf
	sudo echo "root soft     nofile         655350" >> /etc/security/limits.conf
	sudo echo "root hard     nofile         655350" >> /etc/security/limits.conf

	# We apply the changes
	sudo sysctl -p
}

addNewUser() {
	echo "========================================================================="
	echo "|                  Adding a new user and configuring                    |"
	echo "========================================================================="
	# We generate a random name for the new user
	choose() { echo ${1:RANDOM%${#1}:1} $RANDOM; }
	username="$({ choose 'abcdefghijklmnopqrstuvwxyz'
	  for i in $( seq 1 $(( 6 + RANDOM % 4 )) )
	     do
	        choose 'abcdefghijklmnopqrstuvwxyz'
	     done
	 } | sort -R | awk '{printf "%s",$1}')"

	# We generate a random password for the new user
	# We avoid adding symbols inside the password as it sometimes caused problems, therefore the password lenght is high
	choose() { echo ${1:RANDOM%${#1}:1} $RANDOM; }
	password="$({ choose '123456789'
	  choose 'abcdefghijklmnopqrstuvwxyz'
	  choose 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	  for i in $( seq 1 $(( 18 + RANDOM % 4 )) )
	     do
	        choose '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
	     done
	 } | sort -R | awk '{printf "%s",$1}')"

	 # We create a new user
	adduser --gecos "" --disabled-password $username

	# We set a password for the new user
	chpasswd <<<"$username:$password"

	# We grant root privileges to the new user
	usermod -aG sudo $username

	# We save the new user credentials to use after switching user
	# We first must check if it already exists or not
	# If it does exist, we must delete it and make a new one to store new temporary data
	if [ -d "/temphysteria2folder" ]
	then
	    rm -r /temphysteria2folder
		sudo mkdir /temphysteria2folder
	else
		sudo mkdir /temphysteria2folder
	fi

	echo $username > /temphysteria2folder/tempusername.txt
	echo $password > /temphysteria2folder/temppassword.txt
	echo $latestsingboxversion > /temphysteria2folder/templatestsingboxversion.txt

	# We transfer ownership of the temp folder to the new user, so the new user is able to Access and delete the senstive information when it's no longer needed
	sudo chown -R $username /temphysteria2folder/
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

	# We check update pakcages argument
	if [ $1 = "-dpu" ]; then
		disablePackageUpdating=1
	fi

done

showStartupMessage

# We check wether the method is supplied at execution or not
# if not, we ask the user by calling the askTunnelingMethod function
if [ ! -v tunnelingMethod ]; then
	askTunnelingMethod
fi

# We check wether user requested to disable package updating or not
# If so we will skip this step
if [ ! -v disablePackageUpdating ]; then
	installPackages
fi

# We call the function to set up the specified tunneling method
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