#!/bin/bash

if [ ! -d "results_fst" ]; then
        echo "create results_fst"
        mkdir results_fst  ### All output goes here ###
fi
echo "directory 'results_fst' exists"
date

### infiles ###
F1=$1 ### list containing population names ###
thresh=$2

#loci=$2 ### list of common loci ###
n=$(wc -l $F1 | awk '{print $1}')

### calculate all pairwise Fst's ###
x=1
while [ $x -le $n ] 
do
	y=$(( $x + 1 ))
	while [ $y -le $n ]
	do
	
	pop1=$( (sed -n ${x}p $F1) )  
	pop2=$( (sed -n ${y}p $F1) )

		#sbatch -p med -t 1440 --mem=32G 09b_get_fst.sh $pop1 $pop2 #$loci
		sbatch -p med -t 2400 09b_get_fst.sh $pop1 $pop2 $thresh
	y=$(( $y + 1 ))
	
	done

x=$(( $x + 1 ))

done

