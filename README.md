# TunlDigr
 
## Arguments
### `-tm` (tunneling method) :
- `h2` : Hysteria 2
- `xr` : Reality
- `ss` : Shadowsocks  
### `-dpu` (disable package updating) :
by adding this flag, the script will *NOT* update repositories and install required packages.  
useful if you already have the following packages installed:  
`wget` `tar` `openssl` `gawk` `sshpass` `ufw` `coreutils` `curl` `adduser` `sed` `grep` `util-linux` `qrencode` `unzip` `snapd` `haveged`  
### `-dso` (disable server optimization) :
by adding this flag, the script will *NOT* optimize the `sysctl.conf` and `limits.conf` file
