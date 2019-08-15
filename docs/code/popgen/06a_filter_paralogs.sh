#!/bin/bash

#mkdir results_paralogs  ### All output goes here ###
#mkdir results_loci

infile=$1 ### list containing population names ###
thresh=$2
ref='final_contigs_300.fa' ### reference fasta file used in alignment ###
n=$(wc -l $infile | awk '{print $1}')

### Calculate paralog probabilities and get a list of paralogous loci  ###

x=1
while [ $x -le $n ] 
do

	pop=$(sed -n ${x}p $infile)

		echo "#!/bin/bash" > ${pop}_paralog.sh
		echo "" >> ${pop}_paralog.sh
		echo "#SBATCH -o out_slurms/05b_paralogs-%j.out" >> ${pop}_paralog.sh
		echo "" >> ${pop}_paralog.sh

		echo "samtools mpileup -b bamlists/${pop}_${thresh}k_thresh.bamlist -l results_snp/${pop}_${thresh}k.snp.pos -f ${ref} > results_paralogs/${pop}_${thresh}k.depth" >> ${pop}_paralog.sh
		echo "~/bin/ngsParalog/ngsParalog calcLR -infile results_paralogs/${pop}_${thresh}k.depth > results_paralogs/${pop}_${thresh}k.paralogs" >> ${pop}_paralog.sh
		echo "awk '(\$5 > '100')' results_paralogs/${pop}_${thresh}k.paralogs | cut -c1-7 | uniq > results_paralogs/${pop}_${thresh}k.paralogs.list" >> ${pop}_paralog.sh
		echo "grep '>' $ref | cut -c2- | grep -v -f results_paralogs/${pop}_${thresh}k.paralogs.list | sed 's/$/:/' > results_loci/${pop}_${thresh}k.loci" >> ${pop}_paralog.sh
		sbatch -J rpparlog -t 2880 --mem=60G -c 1 ${pop}_paralog.sh

	x=$(( $x + 1 ))

done

