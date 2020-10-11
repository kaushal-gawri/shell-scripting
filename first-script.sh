#!/bin/bash
# don't know if it will work
#trap end_monitor SIGUSR1
#trap 'echo "Signal Found"; exit 1' USR1
#trap 'echo "Your pressed control"; exit 1' 0 1 2 15
#trap "echo yo" INT TERM
#wait
flag=1
val=0
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
#trap '' USR1
trap end_monitor USR1 EXIT
#trap 'echo "usr1er: EXIT received, sending USR1"; kill -USR1 $PPID' TERM
#trap "echo trap invoked" USR1
#trap end_monitor USR1
echo "Flag before if $flag"
echo "Initial $val"
b=20
if [ "$val" -eq "$b" ]
then	
#	trap end_monitot USR1 EXIT
	exit 1
fi
#if [ $flag==0 ]
#then
#	exit 1
#fi
echo "Completed if"
temp=$(vcgencmd measure_temp)
#cat '{$1},(temp)' > file.txt  <<EOF
cat >> newFile.txt <<EOF
$1	$temp
EOF
sleep 5
s=5
val=$(($1+$s))
echo "Val is $val"
if [ $flag!=0 ]
then	
	trap end_monitor USR1 EXIT
	read_status $val
fi
#read_status $val
#trap end_monitor USR1
}

#trap end_monitor USR1 EXIT
#echo "Ends"
