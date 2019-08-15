#!/bin/bash

#mkdir results_thetas  ### All output goes here ###

infile=$1 ### list containing population names ###
thresh=$2
#ref=$3 ### reference fasta file with ancetral states ###
n=$(wc -l $infile | awk '{print $1}')

### Calculate saf files and the ML estimate of the sfs using the EM algorithm for each population ###
x=1
while [ $x -le $n ] 
do

	pop=$(sed -n ${x}p $infile)

		echo "#!/bin/bash" > ${pop}_thetas.sh
		echo "" >> ${pop}_thetas.sh
		echo "#SBATCH -o out_slurms/08_thetas-%j.out" >> ${pop}_thetas.sh
	 	echo "" >> ${pop}_thetas.sh	

		#1. Calculate the thetas per site (or bait) (again from a folded sfs if no ancestral avail)
		echo "angsd -bam bamlists/${pop}_${thresh}_thresh.bamlist -out results_thetas/${pop}_${thresh} -ref final_contigs_300.fa -anc final_contigs_300.fa -sites bait_lengths.txt -GL 2 -doThetas 1 -doSaf 1 -fold 1 -pest results_folded_sfs/${pop}_${thresh}.folded.sfs" >> ${pop}_thetas.sh
		echo "thetaStat make_bed results_thetas/${pop}_${thresh}.thetas.gz" >> ${pop}_thetas.sh
		echo "thetaStat do_stat results_thetas/${pop}_${thresh}.thetas.gz -nChr $n" >> ${pop}_thetas.sh
		# 2. calculate thetaStats and TajD
		echo "thetaStat do_stat results_thetas/${pop}_${thresh}.thetas.idx -nChr $n" >> ${pop}_thetas.sh
		# 3.  Calc genome wide thetastats with sliding window analysis of 1, output is idx.pestPG
		echo "thetaStat do_stat results_thetas/${pop}_${thresh}.thetas.idx -win 1 -step 1 -outnames results_thetas/${pop}_${thresh}_gw_thetasWin.gz" >> ${pop}_thetas.sh

		sbatch -J rapdiv -p med --mem=16G -t 2880 -c 1 ${pop}_thetas.sh
		#sbatch -J rapdiv -p high -t 2880 -c 1 ${pop}_thetas.sh

	x=$(( $x + 1 ))

done

