#!/bin/bash

#SBATCH -o /home/rapeek/projects/rangewide/pop_gen/out_slurms/02c_get_depth-%j.out

if [ ! -d "results_depth" ]; then
	echo "create results_depth"
	mkdir results_depth  ### All output goes here ###
fi
echo "directory exists"
date

infile=$1 ### list containing population names ###

angsd -bam bamlists/${infile}_thresh.bamlist -doDepth 1 -out results_depth/${infile} -doCounts 1 -minMapQ 30 -minQ 20 -sites bait_lengths.txt

echo "all done"
