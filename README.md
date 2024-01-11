# TunlDigr
 
## General Arguments
### `-tm` (tunneling method):
- `h2` : Hysteria 2
- `xr` : Reality
- `ss` : Shadowsocks

### `-dpu` (disable package updating):
by adding this flag, the script will *NOT* update repositories and install required packages.  
useful if you already have the following packages installed:  
`wget` `tar` `openssl` `gawk` `sshpass` `ufw` `coreutils` `curl` `adduser` `sed` `grep` `util-linux` `qrencode` `unzip` `snapd` `haveged`  

### `-dso` (disable server optimization):
by adding this flag, the script will *NOT* optimize the `sysctl.conf` and `limits.conf` file  

### `-setusername` (set custom username):
the script generates a random username each time, you can override this behaviour and provide your custom username to be used when creating a new user  

### `-setuserpass` (set custom password):
the script generates a random password each time, you can override this behaviour and provide your custom password to be used when creating a new user  

---

## Hysteria Arguments
### `-seth2sslcn` (set custom SSL certificate common name) (CN):  
you can set custom common name for SSL certificate  
default: `google-analytics.com`  

### `-seth2obfspass` (set custom hysteria obfs password):
you can set custom password for hysteria obfs (salamander)  
default is random

---

