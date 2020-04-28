#!/bin/bash

#Adding the date to overwite any past runs
date > Process.csv
date > ps.txt
date > iostat.txt
date > ifstat.txt
date > df.txt
date > System_Metrics.csv
date > APM1_Metrics.csv
date > APM2_Metrics.csv
date > APM3_Metrics.csv
date > APM4_Metrics.csv
date > APM5_Metrics.csv
date > APM6_Metrics.csv
echo "Seconds, RX, TX, Disk Write, Available Space" >> System_Metrics.csv

#Globally declare variables to use.
$seconds
$RX_TX
$RX
$TX
$Disk_write
$Avail_Space
$toWrite
$ens
ens=`ifconfig | awk '{print $1}' | head -1 | sed 's/://g'`

#Made all of the data collection be assigned to a variable and then be written to a file (System_Metrics.csv)
function collect() {
	seconds=$SECONDS
	#ps -a -o cmd, -o %cpu, -o %mem | grep "..APM*" >> APM_Metrics.csv
	#ps -a -o %c  -o ,%C, -o %mem
	#ps -a -o cmd, -o %cpu, -o %mem | grep "..APM1" >> APM1_Metrics.csv
	ps -a -o cmd  -o ,%C, -o %mem | grep "..APM1" >> APM1_Metrics.csv
	ps -a -o cmd  -o ,%C, -o %mem | grep "..APM2" >> APM2_Metrics.csv
	ps -a -o cmd  -o ,%C, -o %mem | grep "..APM3" >> APM3_Metrics.csv
    ps -a -o cmd  -o ,%C, -o %mem | grep "..APM4" >> APM4_Metrics.csv
	ps -a -o cmd  -o ,%C, -o %mem | grep "..APM5" >> APM5_Metrics.csv
    ps -a -o cmd  -o ,%C, -o %mem | grep "..APM6" >> APM6_Metrics.csv

	#Find gets the % mem and % CPU of each process running on the system the filters for the APM files
	Disk_Write=`iostat -d sda | awk '{print $4}' | tail -2`
	#
	#echo $Disk_Write
	Avail_Space=`df -BM / | awk '{print $4}' | sed  's/M//g' | tail -1`
	#
	#echo $Avail_Space
	RX_TX=`ifstat --interval=1 $ens | awk '{ print $6, $7, $8, $9 }' | tail -2 | head -1 | awk '{print $1,$3}'`
	RX=`echo $RX_TX | awk '{print $1}' | sed  's/K/000/g'`
	TX=`echo $RX_TX | awk '{print $2}' | sed  's/K/000/g'`
        #echo $RX_TX
	#Finds the TX and RX data rates coming from ens33 the outside facing interface
	toWrite=$seconds','$RX','$TX','$Disk_Write','$Avail_Space
	echo $toWrite >> System_Metrics.csv
}

#ipToUse=192.168.195.129
#hostname -I | sed 's/\s.*$//'
ipToUse=`hostname -I | awk '{print $1}'`

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
	killall APM* > /dev/null 2>&1
	#Kills all of the APM named processes
}

function FileCheck() {
if test -f "$1"; then
	rm "$1"
fi
}

RunC
end=$((SECONDS+900))
#Running for exactly 15 mins
while [ $SECONDS -lt $end ];
do
	#echo "Collecting"
	#collect
	#Sleep 4 because it takes about a second to run
	#sleep 4

	#Attempted to make it run when Seconds % 5 was 0, did not work.
	#echo "Collecting"
	funf=$((SECONDS%5))
	if [ $funf -eq 0 ]; then 
           echo "$SECONDS"
           collect
	   sleep 1
	fi
done
Kill
