#!/bin/bash -l 

F1=$1 # input file
n=$(wc -l $F1 | awk '{print $1}')

x=1
while [ $x -le $n ]
do

	string="sed -n ${x}p $F1"
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1}')   
	set -- $var
	c1=$1	### Sample name  ###
	
		echo "#!/bin/bash" > ${c1}.sh
		echo "" >> ${c1}.sh

#		echo "perl QualityFilter.pl ${c1}.fastq > ${c1}_L80P80.fastq" >> ${c1}.sh
		echo "perl HashSeqs.pl ${c1}_L80P80.fastq ${c1} > ${c1}_L80P80.hash" >> ${c1}.sh
		echo "perl PrintHashHisto.pl ${c1}_L80P80.hash > ${c1}_L80P80.txt" >> ${c1}.sh
		
		sbatch -c 1 ${c1}.sh

	x=$(( $x + 1 ))

done

