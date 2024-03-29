# [WIP]TunlDigr  
Creates Hysteria 2 / Reality / Shadowsocks tunnels **very fast** with **one command** while having the ability to customize every option if you want.  
Optimized for Iran

- [Features](https://github.com/MohsenHNSJ/TunlDigr?tab=readme-ov-file#features)
- [Requirements](https://github.com/MohsenHNSJ/TunlDigr?tab=readme-ov-file#requires)
- [Usage](https://github.com/MohsenHNSJ/TunlDigr?tab=readme-ov-file#usage)
- [General Arguments](https://github.com/MohsenHNSJ/TunlDigr?tab=readme-ov-file#general-arguments)
- [Hysteria Arguments](https://github.com/MohsenHNSJ/TunlDigr?tab=readme-ov-file#hysteria-arguments)
- [Reality Arguments](https://github.com/MohsenHNSJ/TunlDigr?tab=readme-ov-file#reality-arguments)
- [ShadowSocks Arguments](https://github.com/MohsenHNSJ/TunlDigr?tab=readme-ov-file#shadowsocks-arguments)

# Features:  
- install and run LATEST Reality server with one command for the following architectures: `i386` `i686` `amd64` `x86_64` `armv5tel` `armv6l` `armv7` `armv7l` `arm64` `aarch64` `mips` `mipsle` `mips64` `mips64le` `ppc64` `ppc64le` `riscv64` `s390x` 
- Install and run LATEST Hysteria 2 server with one command for the following architectures: `i386` `i686` `amd64` `x86_64` `amd64v3` `armv7` `armv7l` `arm64` `aarch64` `s390x`
- install and run `shadowsocks-libev` using `snap`
- Update required packages automatically (can be disabled)
- Optimize server settings for best performance (can be disabled)
- Sets up the protocol on a separate user (NOT `root`) that is randomly created (can be customized)
- Configures `ufw` to allow port (can be customized)
- Uses `AVX` optimized package automatically if the machine supports it (`amd64v3`)
- Generates required certificates and keys (CN can be customized)
- Generates QR-Code to connect easily (can be disabled)  

# Requirements:  
1. VPS with Linux OS (Tests were done on Ubuntu 22.04)
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

### `-dpakup` (disable package updating):
by adding this flag, the script will *NOT* update repositories and install required packages.  
useful if you already have the following packages installed:  
`wget` `tar` `openssl` `gawk` `sshpass` `ufw` `coreutils` `curl` `adduser` `sed` `grep` `util-linux` `qrencode` `unzip` `snapd` `haveged`  

### `-dservopti` (disable server optimization):
by adding this flag, the script will *NOT* optimize the `sysctl.conf` and `limits.conf` file.  
_not recommended_   

### `-dconinfo` (disable connection information):  
by adding this flag, the script will *NOT* show the connection information at the end of setup.  
useful in case you have customized everything.  

### `-dqrcode` (disable qr code):
by adding this flag, the script will *NOT* show QR Code at the end of setup.  
useful in case the screen resolution is too small.  

### `-dstartmsg` (disable startup message):  
by adding this flag, the script will *NOT* show the startup message.  

### `-setusername` (set custom username):
the script generates a random username each time, you can override this behavior and provide your custom username to be used when creating a new user.  

### `-setuserpass` (set custom password):
the script generates a random password each time, you can override this behavior and provide your custom password to be used when creating a new user.  

### `-settunnelport` (set custom port for protocol):  
you can set custom port for protocols.  
Acceptable range is `0 - 65535`. if input is invalid, it will be ignored.  
default is `443`  

### `-setservername` (set custom server name):
you can set custom name for the server to show in connection configuration link.  
default is server host name

---

## Hysteria Arguments
### `-seth2sslcn` (set custom SSL certificate common name) (CN):  
you can set custom common name for SSL certificate.  
default: `google-analytics.com`  

### `-seth2obfspass` (set custom hysteria obfs password):
you can set custom password for hysteria obfs (salamander).  
default is random  

### `-seth2userpass` (set custom password):  
you can set custom password for authentication to hysteria 2 protocol.  
default is random  
 
---

## Reality Arguments
### `-setxruuid` (set custom uuid):  
you can set custom UUID for reality protocol.  
default generates random.  

### `-setxrprivkey` (set custom private key):  
you can set custom private key.  
MUST set `-setxrpubkey` too or it will be ignored.  
default generates random.  

### `-setxrpubkey` (set custom public key):  
you can set custom public key.  
MUST set `-setxrprivkey` too or it will be ignored.  
default generates random.  

### `-setxrshortid` (set custom short id):  
you can set custom short ID.  
default generates random.  

### `-setxracslgpath` (set custom access log path):  
The file path for the access log.  
The value is a valid file path, such as "/var/log/Xray/access.log".  
When this item is not specified or is an empty value, the log is output to stdout.  

### `-dxracslg` (disable writing access log):  
Disables writing access logs.  

### `-setxrerrlgpath` (set custom error log path):  
The file path for the error log.  
The value is a valid file path, such as "/var/log/Xray/error.log".  
When this item is not specified or is an empty value, the log is output to stdout.  

### `-dxrerrlg` (disable writing error log):  
Disables writing error logs.  

### `-xrlogl` (set xray log level):  
The log level for error logs, indicating the information that needs to be recorded.  
Acceptable range `0 - 4`.  
The default value is "warning" `3`.  
`0` "none": Do not record any content.  
`1` "debug": Output information used for debugging the program. Includes all "info" content.  
`2` "info": Runtime status information, etc., which does not affect normal use. Includes all "warning" content.  
`3` "warning": Information output when there are some problems that do not affect normal operation but may affect user experience. Includes all "error" content.  
`4` "error": Xray encountered a problem that cannot be run normally and needs to be resolved immediately.    
If input is invalid, the script will revert back to default value.  

### `-xrlogdns` (enable logging DNS queries):  
Whether to enable DNS query logs.  
For example: DOH//doh.server got answer: domain.com -> [ip1, ip2] 2.333ms.  
Default disabled.  


---

## ShadowSocks Arguments  
### `-ssedge` (shadowsocks edge channel):  
by adding this flag, the script will install the edge channel version of `shadowsocks-libev`  

