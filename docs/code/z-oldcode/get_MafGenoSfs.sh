#!/bin/bash -l

### Arguments ###
pop=$1
ref=$2

### Input variables ###
nInd=$(wc -l ${pop}.bamlist | awk '{print $1}')
nChr=$(($nInd*2))
min=$((${nInd}/2))



### Calculate Maf, SFS & Genotypes ### [if no reference, use loci file]
	~/angsd/angsd -bam ${pop}.bamlist -out ${pop} -anc ${ref} -GL 2 -doMajorMinor 1 -doMaf 2 -doGeno 13 -doSaf 1 -doPost 2 -minMapQ 10 -postCutoff 0.80 -fold 1 -minQ 20 -minInd $min

### Unzip all files ###
	gunzip ${pop}*.gz
 
### ML optimization of SFS files via EM algorithm ####
	~/angsd/angsd/misc/realSFS ${pop}.saf $nInd -maxIter 100 > ${pop}.sfs

### Recalculate SFS via using ML optimized SFS as priors ###
#	~/angsd/angsd -bam ${pop}.bamlist -out ${pop}_rf -anc ${ref} -GL 1 -doSaf 1 -pest ${pop}.saf.ml -minMapQ 10 -minQ 20 -minInd $mInd

### Unzip all files ##
#	gunzip ${pop}_rf*.gz

