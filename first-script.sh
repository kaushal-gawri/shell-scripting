#!/bin/bash
# don't know if it will work
#read_status 0
trap end_monitor USR1 EXIT
flag=1
val=0
nano kernel_performance_data
end_monitor()
{
#	echo "Process Ends"
#	echo "Reaches end"
#	flag=0
#	echo "Flag $flag"
	exit 1
}


read_status()
{
echo "Flag before if $flag"
echo "Initial $val"
b=20
#if [ "$val" -eq "$b" ]
#then	
#	exit 1
#fi
echo "Completed if"
temp=$(vcgencmd measure_temp)
#nano kernel_performance_data
cat >> kernel_performance_data <<EOF
$1	$temp
EOF
sleep 1
s=1
val=$(($1+$s))
echo "Val is $val"
if [ $flag!=0 ]
then	
	read_status $val
fi
}
echo "Trap Removed"
read_status 5
#trap end_monitor USR1 EXIT
 
