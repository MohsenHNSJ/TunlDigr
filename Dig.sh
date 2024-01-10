#!/bin/bash

scriptVersion="0.1.7"

askTunnelingMethod() {
	# We check wether the tunneling method is supplied at execution or not
	# If so we will skip this step
	if [ -v tunnelingMethod ]; then
		return 0
	fi

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
	# We check wether user requested to disable package updating or not
	# If so we will skip this step
	if [ -v disablePackageUpdating ]; then
		return 0
	fi

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

optimizeServerSettings() {
	# We check wether user has disabled server settings optimization or not
	# If so we will skip this step
	if [ -v disableServerOptimization ]; then
		return 0
	fi

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

createHysteriaService() {
	echo "========================================================================="
	echo "|                      Creating Hysteria 2 service                      |"
	echo "========================================================================="
	# We create a service file
	sudo echo "[Unit]" > /etc/systemd/system/hysteria2.service
	sudo echo "Description=sing-box service" >> /etc/systemd/system/hysteria2.service
	sudo echo "Documentation=https://sing-box.sagernet.org" >> /etc/systemd/system/hysteria2.service
	sudo echo "After=network.target nss-lookup.target" >> /etc/systemd/system/hysteria2.service
	sudo echo "[Service]" >> /etc/systemd/system/hysteria2.service
	sudo echo "User=$username" >> /etc/systemd/system/hysteria2.service
	sudo echo "Group=$username" >> /etc/systemd/system/hysteria2.service
	sudo echo "CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH" >> /etc/systemd/system/hysteria2.service
	sudo echo "AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH" >> /etc/systemd/system/hysteria2.service
	sudo echo "ExecStart=/home/$username/hysteria2/sing-box -D /home/$username/hysteria2/ run -c /home/$username/hysteria2/config.json" >> /etc/systemd/system/hysteria2.service
	sudo echo "ExecReload=/bin/kill -HUP \$MAINPID" >> /etc/systemd/system/hysteria2.service
	sudo echo "Restart=on-failure" >> /etc/systemd/system/hysteria2.service
	sudo echo "RestartSec=10s" >> /etc/systemd/system/hysteria2.service
	sudo echo "LimitNOFILE=infinity" >> /etc/systemd/system/hysteria2.service
	sudo echo "" >> /etc/systemd/system/hysteria2.service
	sudo echo "[Install]" >> /etc/systemd/system/hysteria2.service
	sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/hysteria2.service
}

switchUser() {
	echo "========================================================================="
	echo "|                           Switching user                              |"
	echo "========================================================================="
	# We now switch to the new user
	sshpass -p $password ssh -o "StrictHostKeyChecking=no" $username@127.0.0.1

	# We read the saved credentials
	tempusername=$(</temphysteria2folder/tempusername.txt)
	temppassword=$(</temphysteria2folder/temppassword.txt)
	templatestsingboxversion=$(</temphysteria2folder/templatestsingboxversion.txt)

	# We delete senstive inforamtion
	rm /temphysteria2folder/tempusername.txt
	rm /temphysteria2folder/temppassword.txt
	rm /temphysteria2folder/templatestsingboxversion.txt

	# We provide password to 'sudo' command and open port 443
	echo $temppassword | sudo -S ufw allow 443
}

downloadSingBox() {
	echo "========================================================================="
	echo "|               Downloading Sing-Box and required files                 |"
	echo "========================================================================="
	then
	    rm -r /temphysteria2folder
		sudo mkdir /temphysteria2folder
	else
		sudo mkdir /temphysteria2folder
	fi

	# We create directory to hold Hysteria files
	# If it does exist, we must delete it and make a new one to avoid conflicts
	if [ -d "/hysteria2" ]; then
		rm -r /hysteria2
	fi
	mkdir hysteria2

	# We navigate to directory we created
	cd hysteria2/

	# We check and save the hardware architecture of current machine
	hwarch="$(uname -m)"

	case $hwarch in 
	x86_64)
	# We check if cpu supprt AVX
	avxsupport="$(lscpu | grep -o avx)"

	if [ -z "$avxsupport" ];
	then 
		echo "AVX is NOT supported"
		hwarch="amd64"
	else
		echo "AVX is Supported"
		hwarch="amd64v3"
	fi
	;;
	aarch64)
	hwarch="arm64" ;;
	armv7l)
	hwarch="armv7" ;;
	*)
	echo "This architecture is NOT Supported by this script. exiting ..."
	exit ;;
	esac

	# We download the latest suitable package for current machine
	wget https://github.com/SagerNet/sing-box/releases/download/v$latestsingboxversion/sing-box-$latestsingboxversion-linux-$hwarch.tar.gz

	# We extract the package
	tar -xzf sing-box-$latestsingboxversion-linux-$hwarch.tar.gz --strip-components=1 sing-box-$latestsingboxversion-linux-$hwarch/sing-box

	# We remove downloaded file
	rm sing-box-$latestsingboxversion-linux-$hwarch.tar.gz

	# We create certificate keys
	openssl ecparam -genkey -name prime256v1 -out ca.key
	openssl req -new -x509 -days 36500 -key ca.key -out ca.crt -subj "/CN=google-analytics.com"
}

installHysteria() {
	echo
	echo "installing Hysteria 2"

	# We check and save the latest version number of Sing-Box
	latestsingboxversion="$(curl --silent "https://api.github.com/repos/SagerNet/sing-box/releases/latest" | grep -Po "(?<=\"tag_name\": \").*(?=\")"  | sed 's/^.//' )"

	optimizeServerSettings

	addNewUser

	createHysteriaService

	switchUser

	downloadSingBox
}

installReality() {
	echo "installing Reality (XTLS VLESS)"
}

installShadowSocks() {
	echo "installing ShadowSocks"
}

# We iterate through all provided arguments
while [ ! -z "$1" ]; do
	case "$1" in
		# Tunneling method
		-tm)
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
			if [ $1 == "ss" ]; then
				tunnelingMethod=3	
			fi
			;;
		# Disable package updating
		-dpu)
			disablePackageUpdating=1
			;;
		# Disable server settings optimization
		-dso)
			disableServerOptimization=1
			;;
	esac
shift
done

showStartupMessage

askTunnelingMethod

installPackages

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