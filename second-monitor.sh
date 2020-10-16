#!/bin/bash
#Trapping the USR2 signal sent from kernel_build.sh 
trap end_monitor USR2 EXIT
#Using a global variable, flag, to terminate the while loop used in trigger_LED()
flag=0
#This is a function responsible for updating flags value and exiting once USR2 signal received.
end_monitor()
{
flag=1
exit 1
}

#This is a function used to trigger the led based on CPU Usage
trigger_LED()
{
#Declaring a local variable to be used for terminating condition
e=1
#Looping through until flag valu is updated to 1
while [ $flag -ne $e ]
do
#Calculating the Cpu-usage idle % using sar with awk, grep is used to find any keyword with CPU in it and awk is used to print the 9th column
CPU_IDLE=$(sar -u 1 1 | grep -v "CPU" | awk '{printf$9}')
val=100.00
#Calculating the Cpu-usage busy % by taking complement of CPU_IDLE
#Using bc for the floating number
CPU_USAGE=$( bc <<< "$val - $CPU_IDLE" )
#Finding the fraction to be used to sleep in between the different state of led as required
#For example, if CPU_USAGE is 40, curr will be 40/100
#using bc for floating numbers
curr=$( bc <<< "$CPU_USAGE" / $val )
#Converting the fraction used above to decimals, to be used to sleep between different state of leds
myVar=$( echo "scale=4; $curr" | bc )
#led0 is displayed for green led, echo input turns on the led for green light, a specific event used present in trigger
#I have tested it thoroughly and it works perfectly fine
#Using sudo becuase directory is in root
	sudo sh -c "echo input > /sys/class/leds/led0/trigger"
#Sleeping for the fraction of a second
	sleep "$myVar" 
#Changing state back to default, that is switching off the led
	sudo sh -c "echo mmc0 > /sys/class/leds/led0/trigger"
#Sleeping again for 1 second before next observation
	sleep 1
done
}
#Invoking the trigger_LED function to start the process of lighting the led
trigger_LED

