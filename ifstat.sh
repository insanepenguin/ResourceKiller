#!/bin/bash

pidof ifstat.sh >> pid.txt
while [ $SECONDS -le 30 ]; do
	ifstat >> ifstat.txt
	echo "****************************************************************" >> ifstat.txt
	sleep 1
done

