#!/bin/bash

function Prep() {
FileCheck "pid.txt"
FileCheck "iostat.txt"
FileCheck "df.txt"
FileCheck "ifstat.txt"
FileCheck "ps.txt"
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
	./APM1 192.168.195.128 &
	./APM2 192.168.195.128 &
	./APM3 192.168.195.128 &
	./APM4 192.168.195.128 &
	./APM5 192.168.195.128 &
	./APM6 192.168.195.128 &
}
function StartCollection() {
	bash ps.sh
	bash ifstat.sh
} 
function Kill() {
	killall APM*
	Kill ps.sh
	Kill ifstat.sh
}

function FileCheck() {
if test -f "$1"; then
	rm "$1"
fi
}
RunC
count = 1
while [ $count -le 16 ];
do
	#Measure here ifstat every 1, PS every 5 
	StartCollection
	
	echo "$count"
	(($count++))
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

