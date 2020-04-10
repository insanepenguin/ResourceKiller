#!/bin/bash

#TO PROPERLY RUN THE PROGRAM, PASS IN 2 ARGUMENTS (1st one is how many seconds to run it) (2nd one is the IP to do it)

date > ps.txt
date > iostat.txt
date > ifstat.txt
date > df.txt

function Prep() {
FileCheck "pid.txt"
FileCheck "iostat.txt"
FileCheck "df.txt"
FileCheck "ifstat.txt"
FileCheck "ps.txt"
}
#FIX THIS FUNCTION
function System() {
	ps -a -o pid,ppid,cmd,%mem,%cpu --sort=-%mem >> ps.txt
	iostat >> iostat.txt
	df >> df.txt
	echo "****************************************************************" >> ps.txt
	echo "****************************************************************" >> iostat.txt
	echo "****************************************************************" >> df.txt
}
function Stat() {
	pidof ifstat.sh >> pid.txt
	ifstat >> ifstat.txt
	echo "****************************************************************" >> ifstat.txt

}

ipToUse=$2

function RunC() {
	./APM1 $ipToUse &
	./APM2 $ipToUse &
	./APM3 $ipToUse &
	./APM4 $ipToUse &
	./APM5 $ipToUse &
	./APM6 $ipToUse &
}
function StartCollection() {
	Stat
	System
} 
function Kill() {
	killall APM*
	
}

function FileCheck() {
if test -f "$1"; then
	rm "$1"
fi
}
RunC
count=1
while [ $count -le $1 ];
do
	#Measure here ifstat every 1, PS every 5
	if [ $(($count % 5)) == 0 ];
	then
		StartCollection
	else
		Stat
	fi
	sleep 1
	echo "$count"
	((count++))
done
Kill

