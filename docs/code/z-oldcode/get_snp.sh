#!/bin/bash

mkdir results_snp  ### All output goes here ###

infile=$1 ### list containing population names ###
ref=$2 ### reference fasta file used in alignment ###
n=$(wc -l $infile | awk '{print $1}')

### Calculate maf and snps ###

x=1
while [ $x -le $n ] 
do

	pop=$(sed -n ${x}p $infile)

		echo "#!/bin/bash" > ${pop}.sh
		echo "" >> ${pop}.sh
		echo "angsd -bam ${pop}.bamlist -out results_snp/$pop -ref $ref -GL 2 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMapQ 10 -minQ 20" >> ${pop}.sh
		echo "gunzip results_snp/${pop}*.gz" >> ${pop}.sh
		echo "cut -d$'\t' -f1-2  results_snp/${pop}.mafs | sed 1d > results_snp/${pop}.snp.pos" >> ${pop}.sh
		echo "cut -d$'\t' -f1  results_snp/${pop}.mafs | sed 1d | sort | uniq -c | awk '{print $1, $2}' > results_snp/${pop}.snp.pos" >> ${pop}.sh
		sbatch --mem=60G -t 2880 -c 1 ${pop}.sh

	x=$(( $x + 1 ))

done

