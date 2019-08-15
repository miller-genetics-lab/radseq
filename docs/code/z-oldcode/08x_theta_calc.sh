#!/bin/bash -l
#SBATCH -o slurm_outs/11_theta_calc-%j.out
#SBATCH --mem 16G 
#SBATCH -t 1-00:00:00

mkdir thetas
#ls /home/djprince/active_projects/Pulldown_3/alignments/Ch_*sorted_proper_rmdup.bam | grep -v _320_  > thetas/Ch.bamlist
thetalist=$1
#ls thetas/*bamlist | sed 's/.bamlist//g' | sed 's:thetas/::g' > thetalist
wc=$(wc -l thetalist | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p thetalist" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        c1=$1

	#genome="/home/djprince/genomes/mykiss/02_Palti/omyV6Chr.fa"
	#region="omy28:11500000-11850000"
	nInd=$(wc -l thetas/${c1}.bamlist | awk '{print $1}')
	nChr=$(echo $[2* ${nInd}])
	minInd=$(echo $[$nInd/2])
 
       angsd -bam thetas/${c1}.bamlist -out thetas/${c1}_reg -anc $genome -minInd $minInd -minQ 20 -minMapQ 10 -GL 1 -doSaf 1 -r $region
       /home/djprince/programs/angsd/misc/realSFS -tole 1e-12 thetas/${c1}_reg.saf.idx > thetas/${c1}_reg.sfs
	angsd -bam thetas/${c1}.bamlist -out thetas/${c1}_reg -anc $genome -minInd $minInd -minQ 20 -minMapQ 10 -GL 1 -doSaf 1 -doThetas 1 -pest thetas/${c1}_reg.sfs -r $region


	/home/djprince/programs/angsd/misc/thetaStat do_stat thetas/${c1}_reg.thetas.idx -win 1 -step 1 -outnames thetas/${c1}.thetasWindow.gz 
        
x=$(( $x + 1 ))

done
rm thetalist
