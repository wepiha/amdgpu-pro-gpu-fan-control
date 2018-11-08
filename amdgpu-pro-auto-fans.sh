#!/bin/bash

temp1_target=40
temp1_max=65

temp1_delta=$((temp1_max - temp1_target))

fan1_min=102
fan1_max=255
fan1_delta=$((fan1_max - fan1_min))

gpu=0
if [ "$1" != "" ]; then
        gpu=$1
fi


set `ls /sys/class/drm/card$gpu/device/hwmon` > /dev/null
export gpu_path=/sys/class/drm/card$gpu/device/hwmon/$1

fan1_percent=0

if [ -d $gpu_path ]; then
        sudo chown $USER "$gpu_path"/pwm1_enable
        sudo chown $USER "$gpu_path"/pwm1

        sudo echo "1" > $gpu_path/pwm1_enable

        temp1_input=`cat $gpu_path/temp1_input`
        temp1_input=$((temp1_input / 1000))

        if [ $temp1_input -ge $temp1_target ] ; then
                fan1_output=$(bc <<< "scale=1; ((($temp1_input - $temp1_target)/$temp1_delta)*$fan1_delta)+$fan1_min")
                fan1_output=`echo $fan1_output | awk '{print int($1+0.5)}'`

                fan1_percent=$(bc <<< "scale=1; ((($fan1_output/$fan1_max))*100)")

        else
                fan1_output=0
        fi


        echo "GPU Temp: $temp1_input"$'\xe2\x84\x83'
        echo "Fan Speed: $fan1_percent%"

        sudo echo -n "$fan1_output" >> $gpu_path/pwm1

else
        echo Could not monitor gpu $gpu.
        echo "($gpu_path not found)"
fi
