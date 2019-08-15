#!/bin/bash
# This script basically moves through lines one at a time, using one columns value to replace another columns value
# This particular use is to concatenate all the 3 runs of each individual into a single file, done twice for RA, RB
x=1
while [ $x -le 32 ]
do

	string="sed -n ${x}p Pupfish_names2" #file which lists all the names
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1,$2,$3}')   
	set -- $var
	c1=$1
	c2=$2  #not used in this particular script
	c3=$3  #not used in this particular script

	cat ${c1}_?_RA.fastq > ${c1}_RA.fastq
	cat ${c1}_?_RB.fastq > ${c1}_RB.fastq


	x=$(( $x + 1 )) #This moves the loop to the next line

done



