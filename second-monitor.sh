#!/bin/bash
#This is idle cpu value
#Confirm this
trap end_monitor USR2 EXIT
flag=0
end_monitor()
{
flag=1
exit 1
}

trigger_LED()
{
e=1
while [ $flag -ne $e ]
do
CPU_IDLE=$(sar -u 1 1 | grep -v "CPU" | awk '{printf$9}')
echo "$CPU_IDLE"
val=100.00
CPU_USAGE=$( bc <<< "$val - $CPU_IDLE" )
echo "$CPU_USAGE"
#newVal=20.00
#div=5
curr=$( bc <<< "$CPU_USAGE" / $val )
myVar=$( echo "scale=4; $curr" | bc )
	sudo sh -c "echo input > /sys/class/leds/led0/trigger"
	sleep $myVar 
	sudo sh -c "echo mmc0 > /sys/class/leds/led0/trigger"
	sleep 1
done
}
#
trigger_LED
echo "Trigger Ended"

