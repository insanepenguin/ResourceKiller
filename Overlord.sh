#!/bin/bash

function Prep() {
FileCheck "pid.txt"
FileCheck "iostat.txt"
FileCheck "df.txt"
FileCheck "ifstat.txt"
FileCheck "ps.txt"
}
function StartAPMS() {
start "APM1" &
start "APM2" &
start "APM3" &
start "APM4" &
start "APM5" &
start "APM6" &
}
function StartCollection() {

}
function Purge() {

}

function FileCheck() {
if test -f "$1"; then
	rm "$1"
fi
}

iostat >> iostat.txt
df >> df.txt

sleep 65

#gets line but now specify cpu and mem %s
cat ps.txt | grep "APM1" >> APM1_metrics.csv
cat ps.txt | grep "APM2" >> APM2_metrics.csv
cat ps.txt | grep "APM3" >> APM3_metrics.csv
cat ps.txt | grep "APM4" >> APM4_metrics.csv
cat ps.txt | grep "APM5" >> APM5_metrics.csv
cat ps.txt | grep "APM6" >> APM6_metrics.csv

