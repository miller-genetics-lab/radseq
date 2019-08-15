#!/bin/bash

#mkdir results_sfs  ### All output goes here ###

infile=$1 ### list containing population names ###
thresh=$2
n=$(wc -l $infile | awk '{print $1}')

### calculate all pairwise 2dsfs's ###
x=1
while [ $x -le $n ] 
do
	y=$(( $x + 1 ))
	while [ $y -le $n ]
	do
	
	pop1=$( (sed -n ${x}p $infile) )  
	pop2=$( (sed -n ${y}p $infile) )

		echo "#!/bin/bash" > ${pop1}.${pop2}.sh
		echo "" >> ${pop1}.${pop2}.sh	
		echo "#SBATCH -o out_slurms/06_joint2dsfs-%j.out" >> ${pop1}.${pop2}.sh
		echo "" >> ${pop1}.${pop2}.sh
		echo "realSFS results_folded_sfs/${pop1}_${thresh}.folded.saf.idx results_folded_sfs/${pop2}_${thresh}.folded.saf.idx > results_folded_sfs/${pop1}.${pop2}_${thresh}.folded.2dsfs" >> ${pop1}.${pop2}.sh

		# make sure the total number of samples in each pop is reflected below (here 15 and 15).
		#echo "Rscript ~/scripts/plot2DSFS_2D.R results_sfs/${pop1}.${pop2}.2dsfs 15 15 $pop1 $pop2" >> ${pop1}.${pop2}.sh
		#echo "Rscript ~/scripts/plot2DSFS_2D.R results_folded_sfs/${pop1}.${pop2}_${thresh}.folded.2dsfs $(wc -l bamlists/${pop1}_${thresh}_thresh.bamlist | awk '{print $1}') $(wc -l bamlists/${pop2}_${thresh}_thresh.bamlist | awk '{print $1}') $pop1 $pop2" >> ${pop1}.${pop2}.sh
		#echo "Rscript ~/scripts/plot2DSFS_3D.R results_sfs/${pop1}.${pop2}.2dsfs $(wc -l bamlists/${pop1}.bamlist | awk '{print $1}') $(wc -l bamlists/${pop2}.bamlist | awk '{print $1}') $pop1 $pop2" >> ${pop1}.${pop2}.sh

		#sbatch -J ryan2dsfs --mem=60G -t 720 -c 1 ${pop1}.${pop2}.sh
		sbatch -J ryan2dsfs -p high --mem=8G -t 2000 -c 1 ${pop1}.${pop2}.sh

	y=$(( $y + 1 ))
	
	done

x=$(( $x + 1 ))

done

