#!/bin/bash -l

pop=$1
n=$(wc -l ${pop} | awk '{print $1}')

x=1
while [ $x -le $n ] 
do

	string="sed -n ${x}p ${pop}"
	str=$($string)

	var=$(echo $str | awk '{print $1, $2, $3}')
	set -- $var
	c1=$1   ### Species Label  ###
	
		samtools view -c -f 1 -F 12 ${c1}_sorted.bam >> no_align.txt
		samtools view -c -f 1 -F 12 ${c1}_sorted_proper.bam >> no_prop.txt
		samtools view -c -f 1 -F 12 ${c1}_sorted_flt.bam >> no_flt_align.txt
		wc -l ${c1}_R1.fastq >> no_R1_reads.txt
#		samtools view -c -f 1 -F 12 ${c1}_ss_sorted_flt.bam >> ss_no_flt_align.txt
	
	x=$(( $x + 1 ))

done

	awk '{c=$1/2; print c}' no_R1_reads.txt > no_reads.txt
	awk '{print $1}' ${pop} > names.txt
	paste -d" " names.txt no_reads.txt no_align.txt no_prop.txt no_flt_align.txt > ${pop}.txt
	sed -i '1iIndv no_reads no_align no_prop no_flt_align' ${pop}.txt
	awk -v OFS="\t" '$1=$1' ${pop}.txt > ${pop}.reads
	rm *.txt


