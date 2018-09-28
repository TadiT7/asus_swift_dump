#!/system/bin/sh

PATH=/system/bin

asuskey3_path="/dev/block/bootdevice/by-name/asuskey3"
props_tmp="000000000000000"
LOG_TAG="asus-latprop"
LOG_NAME="${0}:"
if [ -e "/data/asusdata/SSN" ]; then
    SSN_PATH="/data/asusdata/SSN"
elif [ -e "/factory/SSN" ]; then
    SSN_PATH="/factory/SSN"
elif [ -e "/factory/ISN" ]; then
    SSN_PATH="/factory/ISN"
else
    SSN_PATH=""
fi

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

copy_ssn()
{
    if [ -n "$SSN_PATH" ]; then
        ssn_value=`cat $SSN_PATH`
        logi "usb ssn: $ssn_value"
        usb_serial="${ssn_value}"
    else
        logi "aboot.usb.serial=C4ATAS000000"
        usb_serial="C4ATAS000000"
    fi
    props_tmp="${props_tmp}\naboot.usb.serial=${usb_serial}"
}

set_property_from_file()
{
    file_path=$1
    property=$2
    if [ -e "$file_path" ]
    then
        logi "Set property $property"
        setprop $property `cat $file_path`
    fi
}

set_oem_perf()
{
    if [[ `grep "oem_perf_change" /proc/cmdline` ]];then
        logi "oem_perf_change, set new stats to asuskey3"
        if [[ `grep "oem_perf_on" /proc/cmdline` ]];then
            oem_perf_stats="1"
        else
            oem_perf_stats="0"
        fi
    else
        if [ -f /factory/oem_perf_stats ];then
            logi "no change, set old stats to asuskey3"
            oem_perf_stats=`cat /factory/oem_perf_stats`
        else
            logi "no change and no old stats, set default stats to asuskey3"
            oem_perf_stats="9"
        fi
    fi
    echo -n "aboot.oemperf=${oem_perf_stats}" > $asuskey3_path
}

logi "Start init.asus.lateporp.sh!"

is_oemperf_applied=`getprop persist.sys.oem.perf`
case "$is_oemperf_applied" in
  "applied")
    logi "The property for oemperf is applied!"
    ;;
  *)
    logi "The property for oemperf is NOT applied, reset aboot property!"
    setprop persist.sys.aboot.property ""
    ;;
esac

status=`getprop persist.sys.aboot.property`
#set_property_from_file "/proc/sys/kernel/androidboot_serialno" "ro.bootssn"
#set_property_from_file "/proc/sys/kernel/hwid_info" "ro.hardware.id"
set_property_from_file "/factory/COUNTRY" "ro.config.versatility"
set_property_from_file "/factory/COLOR" "ro.config.idcode"
set_property_from_file "/factory/CUSTOMER" "ro.config.CID"
set_property_from_file "/factory/ISN" "ro.isn"
set_property_from_file "/factory/FSN" "ro.fsn"

case "$status" in
  "copied")
    logi "The property for aboot is copied!"
     ;;
   *)
    logi "Copying property for aboot..."
    dd if=/dev/zero of=$asuskey3_path count=10 bs=512

    while read line;do
        props_tmp="$props_tmp\n$line"
    done < /system/build.prop

    #sync
    copy_ssn
    echo $props_tmp > $asuskey3_path
    setprop persist.sys.aboot.property "copied"
    setprop persist.sys.oem.perf "applied"
    ;;
esac

if [[ `grep "_PR3" /proc/cmdline` ]]; then
    setprop persist.sys.asus.sku "pr3"
elif [[ `grep "_PR" /proc/cmdline` ]]; then
    setprop persist.sys.asus.sku "pr"
elif [[ `grep "_ER" /proc/cmdline` ]]; then
    setprop persist.sys.asus.sku "er"
else
    setprop persist.sys.asus.sku "unknown"
fi

set_oem_perf

exit 0
