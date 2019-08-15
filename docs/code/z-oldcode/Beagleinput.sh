#!/bin/bash -l

bamlist=$1
out=$2
minInd_cutoff_ratio=$3

nInd=$(wc $bamlist | awk '{print $1}')

minInd=$(echo "$nInd*$minInd_cutoff_ratio" | bc)

angsd -bam $bamlist -out $out -nThreads 10 -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -minMaf 0.05 -doGlf 2 






