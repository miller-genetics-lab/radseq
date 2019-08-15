#!/bin/bash -l

pop=$1
n=$(wc -l ${pop} | awk '{print $1}')
ref=$2

	bwa index -a bwtsw ${ref}
	
x=1
while [ $x -le ${n} ] 
do

	string="sed -n ${x}p ${pop}"
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1}')
	set -- $var
	c1=$1   ### Species label ###


		echo "#!/bin/bash" > ${c1}.sh
		echo "" >> ${c1}.sh
		echo "bwa mem ${ref} ${c1}_R1.fastq ${c1}_R2.fastq > ${c1}.sam" >> ${c1}.sh
		echo "samtools view -bS ${c1}.sam | samtools sort - ${c1}_sorted" >> ${c1}.sh
		echo "samtools view -b -f 0x2 ${c1}_sorted.bam > ${c1}_sorted_proper.bam" >> ${c1}.sh
		echo "samtools rmdup ${c1}_sorted_proper.bam ${c1}_sorted_flt.bam" >> ${c1}.sh
		echo "samtools index ${c1}_sorted_flt.bam ${c1}_sorted_flt.bam.bai" >> ${c1}.sh

		sbatch --mem=32G -c 1 ${c1}.sh

	x=$(( $x + 1 ))

done

