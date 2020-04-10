#!/bin/bash

function Prep() {
FileCheck "pid.txt"
FileCheck "iostat.txt"
FileCheck "df.txt"
FileCheck "ifstat.txt"
FileCheck "ps.txt"
}
function System() {
	ps -o pid,ppid,cmd,%mem,%cpu --sort=-%mem | head | sed 's/ /,/g'|cut -d ',' -f4-5 >> ps.txt
	iostat >> iostat.txt
	df >> df.txt
	echo "****************************************************************" >> ps.txt
	echo "****************************************************************" >> iostat.txt
	echo "****************************************************************" >> df.txt
}
function Stat() {
	pidof ifstat.sh >> pid.txt
	# while [ $SECONDS -le 30 ]; do
	# 	ifstat >> ifstat.txt
	# 	echo "****************************************************************" >> ifstat.txt
	# 	sleep 1
	# done
	ifstat >> ifstat.txt
	echo "****************************************************************" >> ifstat.txt

}

# function StartAPMS() {
# start "APM1" &
# start "APM2" &
# start "APM3" &
# start "APM4" &
# start "APM5" &
# start "APM6" &
# }
function RunC() {
	./APM1 192.168.122.1 &
	./APM2 192.168.122.1 &
	./APM3 192.168.122.1 &
	./APM4 192.168.122.1 &
	./APM5 192.168.122.1 &
	./APM6 192.168.122.1 &
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
# iostat >> iostat.txt
# df >> df.txt

# sleep 65

#gets line but now specify cpu and mem %s
cat ps.txt | grep "APM1" >> APM1_metrics.csv
cat ps.txt | grep "APM2" >> APM2_metrics.csv
cat ps.txt | grep "APM3" >> APM3_metrics.csv
cat ps.txt | grep "APM4" >> APM4_metrics.csv
cat ps.txt | grep "APM5" >> APM5_metrics.csv
cat ps.txt | grep "APM6" >> APM6_metrics.csv

