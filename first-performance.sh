#!/bin/bash
ctrlc_count =0
function get_stats()
{
	let ctrlc_count++
	echo
	if [[ $ctrlc_count == 1]]; then
		echo "Stop That."
	elif [[ $ctrlc_count == 2]]; then
		echo "Once more and your quit."
	else
		echo "The End".
		exit
	fi
}

