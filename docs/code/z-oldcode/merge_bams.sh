#!/bin/bash -l

F1=$1
n=$(wc -l $F1 | awk '{print $1}')

x=1
while [ $x -le $n ] 
do

	string="sed -n ${x}p $F1"
	str=$($string)

	var=$(echo $str | awk '{print $1}')
	set -- $var
	c1=$1   ### Individuals go here ###

		echo "#!/bin/bash" > ${c1}.sh
		echo "" >> ${c1}.sh

		echo "samtools merge ${c1}_pop.bam ${c1}???_sorted_flt.bam" >> ${c1}.sh
		echo "samtools index ${c1}_pop.bam ${c1}_pop.bam.bai" >> ${c1}.sh


		sbatch -c 1 ${c1}.sh
	
	x=$(( $x + 1 ))

done

