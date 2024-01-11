# [WIP]TunlDigr  
Creates Hysteria 2 / Reality / Shadowsocks tunnels **very fast** with **one command** while having the ability to customize every option if you want.  
Optimized for Iran

# Features:  
- Install and run LATEST Hysteria 2 server with one command for the following architectures: `amd64` `amd64v3` `arm64` `armv7`
- Update required packages automatically (can be disabled)
- Optimize server settings for best performance (can be disabled)
- Sets up the protocol on a separate user (NOT `root`) that is randomly created (can be customized)
- Configures `ufw` to allow port (can be customized)
- Uses `AVX` optimized package automatically if the machine supports it (`amd64v3`)
- Generates required certificates and keys (CN can be customized)
- Generates QR-Code to connect easily  

# Requires:  
1. VPS with Linux OS outside of Iran and accessible by the user (Tests were done on Ubuntu 22.04)
2. Optionally upgrade all your OS packages to the latest version (for security and performance)  

# Usage:
1. Run the following command in your VPS:  

```
sudo curl -s https://raw.githubusercontent.com/MohsenHNSJ/TunlDigr/main/Dig.sh | bash
```

2. Select the desired protocol
3. Wait a few minutes and scan the QR Code  

---
 
## General Arguments
### `-tm` (tunneling method):  
by specifying this argument, the script will automatically pass the tunnel selection part and proceed to creation.  
useful for one-tap situations.  
- `h2` : Hysteria 2
- `xr` : Reality
- `ss` : Shadowsocks

### `-dpu` (disable package updating):
by adding this flag, the script will *NOT* update repositories and install required packages.  
useful if you already have the following packages installed:  
`wget` `tar` `openssl` `gawk` `sshpass` `ufw` `coreutils` `curl` `adduser` `sed` `grep` `util-linux` `qrencode` `unzip` `snapd` `haveged`  

### `-dso` (disable server optimization):
by adding this flag, the script will *NOT* optimize the `sysctl.conf` and `limits.conf` file.  
_not recommended_  

### `-setusername` (set custom username):
the script generates a random username each time, you can override this behaviour and provide your custom username to be used when creating a new user.  

### `-setuserpass` (set custom password):
the script generates a random password each time, you can override this behaviour and provide your custom password to be used when creating a new user.  

### `-settunnelport` (set custom port for protocol):  
you can set custom port for protocols.  
Acceptable range is `0 - 65535`. if input is invalid, it will be ignored.  
default is `443` 

---

## Hysteria Arguments
### `-seth2sslcn` (set custom SSL certificate common name) (CN):  
you can set custom common name for SSL certificate.  
default: `google-analytics.com`  

### `-seth2obfspass` (set custom hysteria obfs password):
you can set custom password for hysteria obfs (salamander).  
default is random  

### `-seth2userpass` (set custom password for hysteria 2 protocol):  
you can set custom password for authentication to hysteria 2 protocol.  
default is random  
 

---

