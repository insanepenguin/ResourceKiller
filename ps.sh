#!/bin/bash

pidof ps.sh >> pid.txt
while [ $SECONDS -le 5 ]; do
	ps -o pid,ppid,cmd,%mem,%cpu --sort=-%mem | head | sed 's/ /,/g'|cut -d ',' -f4-5 >> ps.txt
	iostat >> iostat.txt
	df >> df.txt
	echo "****************************************************************" >> ps.txt
	echo "****************************************************************" >> iostat.txt
	echo "****************************************************************" >> df.txt
	sleep 5
done


