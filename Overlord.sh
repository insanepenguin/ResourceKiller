#!/bin/bash

#Adding the date to overwite any past runs
date > Process.csv
date > ps.txt
date > iostat.txt
date > ifstat.txt
date > df.txt
date > System_Metrics.csv
echo "Seconds, RX TX, Disk Write, Available Space" >> System_Metrics.csv

#Globally declare variables to use.
$seconds
$RX_TX
$Disk_write
$Avail_Space
$toWrite

function Prep() {
FileCheck "pid.txt"
FileCheck "iostat.txt"
FileCheck "df.txt"
FileCheck "ifstat.txt"
FileCheck "ps.txt"
}

#Made all of the data collection be assigned to a variable and then be written to a file (System_Metrics.csv)
function collect() {
	seconds=$SECONDS
	ps -a -o cmd, -o %cpu, -o %mem | grep "..APM*" >> Process.csv
	#Find gets the % mem and % CPU of each process running on the system the filters for the APM files
	Disk_Write=`iostat -d sda | awk '{print $4}' | tail -2`
	#
	#echo $Disk_Write
	Avail_Space=`df -BM / | awk '{print $4}' | sed  's/M//g' | tail -1`
	#
	#echo $Avail_Space
	RX_TX=`ifstat --interval=1 ens33 | awk '{ print $3, $5 }' | tail -2`
	#echo $RX_TX
	#Finds the TX and RX data rates coming from ens33 the outside facing interface
	toWrite=$seconds','$RX_TX','$Disk_Write','$Avail_Space
	echo $toWrite >> System_Metrics.csv
}

ipToUse=192.168.195.129
#hostname -I | sed 's/\s.*$//'
echo $ipToUse
function RunC() {
	./APM1 $ipToUse &
	./APM2 $ipToUse &
	./APM3 $ipToUse &
	./APM4 $ipToUse &
	./APM5 $ipToUse &
	./APM6 $ipToUse &
	#Starts all of the C programs
}
function Kill() {
	killall APM*
	#Kills all of the APM named processes
}

function FileCheck() {
if test -f "$1"; then
	rm "$1"
fi
}

RunC
end=$((SECONDS+60))
#Running for exactly 15 mins
while [ $SECONDS -lt $end ];
do
	echo "Collecting"
	collect
	#Sleep 4 because it takes about a second to run
	sleep 4

	#Attempted to make it run when Seconds % 5 was 0, did not work.
	#echo "Collecting"
	#if [ $(($SECONDS%5)) -eq 0 ]
		#then collect
	#fi
done
Kill

