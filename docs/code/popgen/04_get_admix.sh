#!/bin/bash -l

#SBATCH -o out_slurms/04_get_admix-%j.out
#SBATCH -J get_admix

#mkdir results_admix

pop=$1 ### bamlist ## (nfy_slate_25k)
ref='final_contigs_300.fa'  #$2
n1=$2  ### k number ###
nInd=$(wc -l bamlists/${pop}_thresh.bamlist | awk '{print $1}')
n=$(($nInd/5))
#mInd=${n%.*}

### Beagle output genotype file ####
	angsd -bam bamlists/${pop}_thresh.bamlist -out results_admix/${pop}_k${n1} -ref $ref -sites bait_lengths.txt -GL 2 -doMajorMinor 1 -doMaf 2 -doPost 2 -doGLF 2 -minMapQ 10 -minQ 20 -minInd $n -SNP_pval 1e-6 -minMaf 0.05

### Unzip files ###

	gunzip results_admix/*${pop}_k${n1}*.gz

### Calculate Admixture & Plot ###

x=3
while [ $x -le $n1 ] 
do
	~/bin/NGSadmix -likes results_admix/${pop}_k${n1}.beagle -K $x -minMaf 0.05 -minInd 2 -seed 21 -o results_admix/${pop}_k${x}_admix
	#Rscript ~/scripts/Admix_plot.R results_admix/${pop}_k${n1}_admix${x}.qopt ${pop}_k${n1}.info $n1
	#mv Rplots.pdf results_admix/${pop}_k${n1}_admix${x}.pdf
#	echo $x >> results_admix/K
#	sed -n '9p' results_admix/${pop}_admix${x}.log | cut -c11-25 >> results_admix/LH

	x=$(( $x + 1 ))

done

### Plot K vs LH ###

#	paste -d' ' results_admix/K results_admix/LH > results_admix/${pop}_admix_LH
#	rm results_admix/K results_admix/LH 
#	Rscript ~/scripts/Admix_LH.R ${pop}_admix_LH
#	mv Rplots.pdf ${pop}_admix_LH.pdf"
