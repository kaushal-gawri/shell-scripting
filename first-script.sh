#!/bin/bash
# don't know if it will work
trap end_monitor USR1
flag=1
#file = "/usr/src/myFile"
#/bin/cat <<EOM >$file
#read status 5

end_monitor()
{
	echo "Process Ends"
	echo "Reaches end"
	flag=0
	echo "Flag $flag"
	exit 1
}

read_status()
{
#trap "echo trap invoked" USR1
#trap end_monitor USR1
echo "Flag before if $flag"
#if [ $flag==0 ]
#then
#	exit 1
#fi
echo "Completed if"
temp=$(vcgencmd measure_temp)
#cat '{$1},(temp)' > file.txt  <<EOF
cat > myFile.txt <<EOF
$1	$temp
EOF
sleep 5
val=$1+5
read_status $val
#trap end_monitor USR1
}
