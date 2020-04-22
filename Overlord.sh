#!/bin/bash



date > ps.txt
date > iostat.txt
date > ifstat.txt
date > df.txt
#Adding the date to overwite any past runs
function Prep() {
FileCheck "pid.txt"
FileCheck "iostat.txt"
FileCheck "df.txt"
FileCheck "ifstat.txt"
FileCheck "ps.txt"
}

function collect() {
	ps -a -o cmd, -o %cpu, -o %mem | grep "..APM*" >> Process.csv
	#Find gets the % mem and % CPU of each process running on the system the filters for the APM files
	iostat -d sda | awk '{print $1,",",$4}' >> iostat.txt
	#
	df -BM / | awk '{print $3}' | grep  'M' >> df.txt
	#
	ifstat --interval=1 ens33 | tr -d \\n  | awk '{ print $24,",", $26 }' >> Network.csv
	#Finds the TX and RX data rates coming from ens33 the outside facing interface
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
	sleep 5
done
Kill

