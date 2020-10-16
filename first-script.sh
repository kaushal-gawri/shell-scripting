#!/bin/bash
#Trapping the USR1 signal sent from kernel_build.sh.
trap end_monitor USR1 EXIT
#Declaring a local variable and using it as a condition to terminate recurssion
flag=1
#Creating a file kernel_performance_data as specified to write time, cpu temperature, throttled state and clock frequency for arm
nano kernel_performance_data
#A function used to terminate the recursion once USR1 signal is trapped
end_monitor()
{	
	flag=0
	exit 1
}

#A recursive function used to write relevant information in the file
read_status()
{
echo "Writing Data to file"
#Using vcgencmd to get cpu temperature and storing in local variable
temp=$(vcgencmd measure_temp)
#using vcgencmd to get throttled state and storing that in local variable
state=$(vcgencmd get_throttled)
#using vcgencmd to get clock frequency for arm
clock=$(vcgencmd measure_clock arm)
#writing data to specified file
cat >> kernel_performance_data <<EOF
$1	$temp	$state	$clock
EOF
#sleeping for one second before getting next value
sleep 1
s=1
#using local variable val to carry out reccursion
val=$(($1+$s))
if [ $flag != 0 ]
then	
	read_status $val
fi
}
#invoking read_status to start writing in file
read_status 1
 
