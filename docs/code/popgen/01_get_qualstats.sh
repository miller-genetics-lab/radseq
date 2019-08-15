#!/bin/bash

#mkdir results_qstats  ### All output goes here ###

infile=$1 ### list containing population names ###
ref='final_contigs_300.fasta' ### reference fasta file used in alignment ###
n=$(wc -l $infile | awk '{print $1}')

x=1
while [ $x -le $n ] 
do

	pop=$(sed -n ${x}p $infile)

	echo "#!/bin/bash" > ${pop}_qs.sh
	echo "" >> ${pop}_qs.sh
	echo "#SBATCH -o /home/rapeek/projects/rangewide/pop_gen/out_slurms/01-qualstats-%j.out" >> ${pop}_qs.sh
	
	echo "angsd -b ${pop}_25k_thresh.bamlist -ref $ref -sites bait_lengths.txt -out results_qstats/$pop -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 -doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth 200 -minQ 0" >> ${pop}_qs.sh
	echo "Rscript ~/scripts/plotQC.R results_qstats/$pop" >> ${pop}_qs.sh
	
	sbatch -J rapQstats --mem=60G -t 1440 ${pop}_qs.sh

	x=$(( $x + 1 ))

done
