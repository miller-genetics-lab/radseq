#!/bin/bash

pop=$1
n=$(wc -l ${pop} | awk '{print $1}')

x=2
while [ $x -le ${n} ] 
do

	string="sed -n ${x}p ${pop}"
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2, $3, $4, $5, $6}')
	set -- $var
	c1=$1   ### Well number ###
	c2=$2	### Old labels ###
	c3=$3	### New labels ###
	c4=$4	### Sex ###
	c5=$5	### Description ###
	c6=$6	### Barcode ###

		mv SOMM065_RA_GG${c6}TGCAGG.fastq ${c3}_R1.fastq 
		mv SOMM065_RB_GG${c6}TGCAGG.fastq ${c3}_R2.fastq 

	x=$(( $x + 1 ))

done

