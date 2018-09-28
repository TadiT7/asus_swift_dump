setprop  persist.service.bdroid.bdaddr  `btnvtool -z 2>&1`
setprop asus.btmac `btnvtool -x 2>&1`
wifi_mac=`grep "MacAddress0" /factory/wifi.nv`
wifi_mac=${wifi_mac//MacAddress0=/ }
setprop asus.wifimac $wifi_mac
