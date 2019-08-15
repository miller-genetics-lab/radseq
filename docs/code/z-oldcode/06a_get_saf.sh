#!/bin/bash

pop=$1 # bamlist
out=$2

nInd=$(wc -l ${pop} | awk '{print $1}')
nChr=$(echo $[2* ${nInd}])
#minInd=$(printf "%.0f" $(echo "scale=2;$minpct*$nInd" | bc))
minInd=$(printf "%.0f" $(echo "scale=2;$nInd" | bc))

echo $pop $nInd $nChr 

# Make SAF
angsd -bam $pop -anc final_contigs_300.fasta -out ./angsd_output/${out}_F -GL 1 -doSaf 1 -minQ 20 -fold 1 #-rf sites_filt5.txt

# Obtain ML estimate of the SFS using realSFS
#/home/rapeek/programs/angsd0.914/angsd/misc/realSFS ./output/${out}_F.saf.gz $nChr > ./output/${out}_F.sfs # can plot that in R using a barplot

# Calculate thetas for each site
#angsd -bam $pop -out ./output/${out}_F -doThetas 1 -doSaf 1 -pest ./output/${out}_F.sfs -anc ./reference/final_contigs_300.fasta -GL 1 -minInd $minInd -fold 1 -rf sites_filt5.txt

# make a binary version of these
#/home/rapeek/programs/angsd0.914/angsd/misc/thetaStat make_bed ./output/${out}_F.thetas.gz

# calculate Tajima's D
#/home/rapeek/programs/angsd0.914/angsd/misc/thetaStat do_stat ./output/${out}_F.thetas.gz -nChr $nChr


