#!/bin/bash

#SBATCH -o out_slurms/09_get_fst-%j.out
#SBATCH -J getFst

echo "Starting Job: "
date

pop1=$1
pop2=$2
thresh=$3
#loci=$3
#n=$(wc -l $loci | awk '{print $1}')

### Calculate index for fst and pbs analysis###

# for unfolded:
#	realSFS fst index results_sfs/${pop1}.saf.idx results_sfs/${pop2}.saf.idx -sfs results_sfs/${pop1}.${pop2}.2dsfs -fstout results_fst/${pop1}.${pop2}

# for folded:
	realSFS fst index results_folded_sfs/${pop1}_${thresh}.folded.saf.idx results_folded_sfs/${pop2}_${thresh}.folded.saf.idx -sfs results_folded_sfs/${pop1}.${pop2}_${thresh}.folded.2dsfs -fstout results_fst/${pop1}.${pop2}_${thresh}.folded

### Calculate global fst and pbs statistics ###

	realSFS fst stats results_fst/${pop1}.${pop2}_${thresh}.folded.fst.idx 2> results_fst/${pop1}.${pop2}_${thresh}_folded_global.fst

echo "Ending Job: "
date

<<'Comment'
### count loci list for loopin to get loci/chr specific fst's and pbs statistics ###

n=$(wc -l $loci | awk '{print $1}')

### prepare header for output file ###

printf 'Loci\tFst_12\n' > results_fst/${pop1}.${pop2}_fst.table

### loop for loci/chr specific fst's and pbs statistics, output to table and clean ###

x=1
while [ $x -le $n ] 
do

	string="sed -n ${x}p $loci"
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1}')
	set -- $var
	c1=$1   ### Species label ###
	
		realSFS fst stats results_fst/${pop1}.${pop2}.fst.idx -r ${c1}: 2> results_fst/${pop1}.${pop2}.out
		printf $c1 > results_fst/${pop1}.${pop2}.loci
		sed -n 4p results_fst/${pop1}.${pop2}.out | cut -d':' -f4 > results_fst/${pop1}.${pop2}.fst
		paste results_fst/${pop1}.${pop2}.loci results_fst/${pop1}.${pop2}.fst >> results_fst/${pop1}.${pop2}_fst.table
		rm results_fst/${pop1}.${pop2}.out results_fst/${pop1}.${pop2}.loci results_fst/${pop1}.${pop2}.fst

	x=$(( $x + 1 ))

done
Comment
