#!/system/bin/sh
# Copyright (c) 2009-2014, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

#
# Function to start sensors for DSPS enabled platforms
#

target=`getprop ro.board.platform`
build_type=`getprop ro.build.type`

start_sensors()
{
    if [ -c /dev/msm_dsps -o -c /dev/sensors ]; then
        chmod -h 775 /persist/sensors
        chmod -h 664 /persist/sensors/sensors_settings
        chown -h system.root /persist/sensors/sensors_settings

        mkdir -p /data/misc/sensors
        chmod -h 775 /data/misc/sensors

        start sensors
    fi
}

case "$target" in
    "msm8909")
        start_sensors
        ;;
    "msm8909w")
        start_sensors
        ;;
    "apq8009")
        start_sensors
        ;;
    "apq8009w")
        start_sensors
        ;;
esac

case "$build_type" in
    "eng")
        setprop persist.debug.sensors.hal i
        setprop debug.qualcomm.sns.libsensor1 0
        setprop debug.qualcomm.sns.daemon 1
        ;;
    "userdebug")
        setprop persist.debug.sensors.hal i
        setprop debug.qualcomm.sns.libsensor1 0
        setprop debug.qualcomm.sns.daemon 1
        ;;
    "user")
        setprop persist.debug.sensors.hal w
        setprop debug.qualcomm.sns.libsensor1 0
        setprop debug.qualcomm.sns.daemon 0
        ;;

esac

#gsensor_K_restore

exit 0
