#!/bin/bash

mkdir results_HWE  ### All output goes here ###

infile=$1 ### list containing population names ###i
threshk=$2
n=$(wc -l $infile | awk '{print $1}')

### Calculate hwe ###

x=1
while [ $x -le $n ] 
do

	pop=$(sed -n ${x}p $infile)

		echo "#!/bin/bash" > ${pop}.sh

		echo "" >> ${pop}.sh
		echo "#SBATCH -o /home/rapeek/projects/rangewide/pop_gen/out_slurms/02_get_HWE-%j.out" >> ${pop}.sh
		#echo"angsd -bam bamlists/${pop}_${threshk}_thresh.bamlist -out results_HWE/${pop}_${threshk} -HWE_pval 0.05 -doMAF 1 -doMajorMinor 1 -GL 1
		echo "angsd -bam bamlists/${pop}_${threshk}_thresh.bamlist -out results_HWE/${pop}_${threshk} -doHWE 1 -domajorminor 1 -GL 1 -doMaf 1 -SNP_pval 1e-6" >> ${pop}.sh
		echo "gunzip results_HWE/${pop}_${threshk}*hwe.gz" >> ${pop}.sh
		sbatch -J rp_hwe --mem=16G -t 2880 -c 1 ${pop}.sh

	x=$(( $x + 1 ))

done
date
