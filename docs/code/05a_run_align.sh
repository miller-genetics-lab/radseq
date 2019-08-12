#!/bin/bash -l

list=$1
ref=$2
#ref=/home/rapeek/projects/SEQS/final_contigs_300.fa

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p ${list}" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2, $3}')   
	set -- $var
	c1=$1
	c2=$2
	c3=$3

	echo "#!/bin/bash -l

bwa mem $ref ${c1} ${c2} | samtools view -Sb - | samtools sort - -o ${c3}.sort.bam
samtools view -f 0x2 -b ${c3}.sort.bam | samtools rmdup - ${c3}.sort.flt.bam" > ${c3}.sh

	sbatch --mem=8G -t 8:00:00 ${c3}.sh

	x=$(( $x + 1 ))

done

