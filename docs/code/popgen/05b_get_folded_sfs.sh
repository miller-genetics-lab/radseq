#!/bin/bash

#mkdir results_folded_sfs  ### All output goes here ###

infile=$1 ### list containing population names ##
thresh=$2 # label for level of subsample/threshold used, i.e., 25k, or 100k
ref='final_contigs_300.fa' ### reference fasta file used in alignment, IMPORTANT!!! Reference must correspond to ancestral states, if not supply a different fasta file for -anc!!! ###
#anc=$3
n=$(wc -l $infile | awk '{print $1}')

### Calculate saf files and the ML estimate of the sfs using the EM algorithm for each population ###
x=1
while [ $x -le $n ] 
do

	pop=$(sed -n ${x}p $infile)

		echo "#!/bin/bash" > ${pop}_folded.sh
		echo "" >> ${pop}_folded.sh
		echo "#SBATCH -o out_slurms/05b_folded_sfs-%j.out" >> ${pop}_folded.sh
		echo "" >> ${pop}_folded.sh
		
		# use folded sfs with -fold 1
		echo "angsd -bam bamlists/${pop}_${thresh}_thresh.bamlist -ref $ref -anc $ref -sites bait_lengths.txt -out results_folded_sfs/${pop}_${thresh}.folded -GL 2 -doSaf 1 -fold 1 -minMapQ 10 -minQ 20" >> ${pop}_folded.sh
		# take sfs
		echo "realSFS results_folded_sfs/${pop}_${thresh}.folded.saf.idx -maxIter 100 > results_folded_sfs/${pop}_${thresh}.folded.sfs" >> ${pop}_folded.sh
		# make a plot
		echo "~/scripts/plotSFS.R results_folded_sfs/${pop}_${thresh}.folded.sfs" >> ${pop}_folded.sh
		#sbatch -J rpfoldsfs --mem=16G -t 2880 -c 1 ${pop}_folded.sh
		sbatch -J rpfoldsfs -t 2880 -p high -c 1 ${pop}_folded.sh
	x=$(( $x + 1 ))

done

