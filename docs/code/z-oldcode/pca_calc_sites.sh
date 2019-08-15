#!/bin/bash -l

bamlist=$1
out=$2
sitesfile=$3
chrsfile=$4

nInd=$(wc $bamlist | awk '{print $1}')

minInd=$[$nInd/2]

angsd -bam $bamlist -out $out -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doGeno 32 -doPost 2 -sites $sitesfile -rf $chrsfile

gunzip ${out}.*.gz

count=$(sed 1d ${out}.mafs | wc -l | awk '{print $1}')

ngsCovar -probfile ${out}.geno -outfile ${out}.covar -nind $nInd -nsites $count -call 1

