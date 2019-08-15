#!/bin/bash -l

pop=$1
n=$(wc -l ${pop} | awk '{print $1}')

x=2
while [ $x -le ${n} ] 
do

        string="sed -n ${x}p ${pop}"
        str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2, $3, $4, $5, $6}')
	set -- $var
	c1=$1   ### Individuals ###
	c6=$6   ### % to sub sample  ###

		echo "#!/bin/bash" > ${c1}.sh
		echo "" >> ${c1}.sh
		echo "samtools view -s ${c6} -b ${c1}_sorted_flt.bam > ${c1}_ss_sorted_flt.bam" >> ${c1}.sh
		
		sbatch -c 1 ${c1}.sh

	x=$(( $x + 1 ))

done

