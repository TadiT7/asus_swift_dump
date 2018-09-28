#!/system/bin/sh

echo 1 > /sys/bus/i2c/devices/5-0048/fw_update
version=$(cat /sys/bus/i2c/devices/5-0048/fw_version)
setprop asus.touch.version "$version"
checksum=$(cat /sys/bus/i2c/devices/5-0048/checksum)
setprop asus.touch.checksum "$checksum"

