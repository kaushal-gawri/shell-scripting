#!/bin/bash
# don't know if it will work
trap end_monitor USR1
file = "/usr/src/myFileNew"
/bin/cat <<EOM >$file
function end_monitor
{
	echo "Process Ends"
	exit 1
}

function read_status
{
#trap end_monitor USR1
temp=$(vcgencmd measure_temp)
echo '{$1},(temp)' > file
sleep 5
read_status {$1}+5
}
