#!/bin/bash -l

#SBATCH -o /home/rapeek/projects/rangewide/pop_gen/out_slurms/03_pca_ibs-%j.out
#SBATCH -J pca_ibs
#SBATCH --mem=60G
#mkdir results_pca

echo "Starting Job: "
date

#<<Comment

bamlist=$1
#out=$2

nInd=$(wc bamlists/${bamlist}_thresh.bamlist | awk '{print $1}')
minInd=$[$nInd/4] # change to 5 for 20% of indiv, or keep stringent at 50%

#Individual runs use this
angsd -bam bamlists/${bamlist}_thresh.bamlist -out results_pca/${bamlist}_thresh  -doIBS 1 -doCounts 1 -doMajorMinor 1 -minFreq 0.05 -maxMis ${minInd} -minMapQ 30 -minQ 20 -SNP_pval 1e-6 -makeMatrix 1 -doCov 1 -GL 1 -doMaf 1 -nThreads 16 -sites bait_lengths.txt

#gunzip results_pca/${out}.mafs.gz

#Comment

### To loop through a list of pops instead of a single bamlist

<<Comment
infile=$1

n=$(wc $infile | awk '{print $1}')

x=1
while [ $x -le $n ] 
do

        pop=$(sed -n ${x}p $infile)
	nInd=$(wc ${pop}_25k_thresh.bamlist | awk '{print $1}')
	minInd=$[$nInd/5]

                echo "#!/bin/bash" > ${pop}_pca.sh
                echo "" >> ${pop}_pca.sh
                echo "#SBATCH -o /home/rapeek/projects/rasi_hybrid/slurm_outs/03_pcaALL_ibs-%j.out" >> ${pop}_pca.sh
		echo "" >> ${pop}_pca.sh

		# for list of pops use this
		echo "angsd -bam ${pop}_25k_thresh.bamlist -out results_pca/${pop} -doIBS 1 -doCounts 1 -doMajorMinor 1 -minFreq 0.05 -maxMis ${minInd} -minMapQ 30 -minQ 20 -SNP_pval 1e-6 -makeMatrix 1 -doCov 1 -GL 1 -doMaf 1 -nThreads 16 -sites bait_lengths.txt" >> ${pop}_pca.sh

		echo "gunzip results_pca/${pop}.mafs.gz" >> ${pop}_pca.sh
		#sbatch -J rap_pca --mem=60G -t 2880 -c 1 ${pop}_pca.sh
date
done
Comment

