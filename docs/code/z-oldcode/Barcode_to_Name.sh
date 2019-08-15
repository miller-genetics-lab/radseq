#!/bin/bash
#This script is used to remove the barcode from file names and replace it with the individual name
x=1
while [ $x -le 96 ] #This can be adjusted based on number of files
do

	string="sed -n ${x}p file" #The file here represents whatever metadate file contains columns of barcodes and names
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1,$2,$3}')   
	set -- $var
	c1=$1
	c2=$2
	c3=$3

	mv SOMM059_index19_RA_GG${c1}TGCAG.fastq ${c2}_RA.fastq
	mv SOMM059_index19_RB_GG${c1}TGCAG.fastq ${c2}_RB.fastq

	x=$(( $x + 1 )) #This will loop the file to the next line

done



