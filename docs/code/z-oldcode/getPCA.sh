#!/bin/bash -l

#export LIBPATH=~/R/x86_64-pc-linux-gnu-library/3.1:LIBPATH

##############################################

pop=$1
ref=$2
#p=$3
nInd=$(wc -l ${pop}.bamlist | awk '{print $1}')
n=$((${nInd}/2))
#mInd=${n%.*}

#############################################

### Build Geno, Maf and SFS files ###

	~/angsd/angsd -bam ${pop}.bamlist -out ${pop} -anc ${ref} -GL 1 -doMajorMinor 1 -doMaf 2 -doGeno 32 -doSaf 1 -doPost 2 -minMapQ 10 -minQ 20 -minInd ${n} -SNP_pval 1e-6 -minMaf 0.05

### Unzip all files ##

	gunzip *${pop}*.gz

##############################################

#n1=$(wc -l ${pop}.saf.pos | awk '{print $1}')
maf=$(wc -l ${pop}.mafs | awk '{print $1}')
n2=$((${maf}-1))

##############################################


### Calculate covariance matrix ###

#	~/ngsTools/ngsPopGen/ngsCovar -probfile ${pop}.geno -outfile ${pop}.covar1 -nind ${nInd} -nsites ${n1} -call 0 -sfsfile ${pop}.saf -norm 0
	~iksaglam/ngsTools/ngsPopGen/ngsCovar -probfile ${pop}.geno -outfile ${pop}.covar2 -nind ${nInd} -nsites ${n2} -call 0
	~iksaglam/ngsTools/ngsPopGen/ngsCovar -probfile ${pop}.geno -outfile ${pop}.covar3 -nind ${nInd} -nsites ${n2} -call 1

# Plot results
#	Rscript --vanilla --slave -e 'write.table(cbind(seq(1,96),rep(1,96),c(rep("CHD",8),rep("CHW",16),rep("COM",12),rep("HUD",11),rep("HUW",12),rep("IBD",12),rep("IBW",12),rep("IRW",13)))), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="Swinw.clst", quote=F)'
#	Rscript ~rapeek/scripts/plotPCA.R -i ${pop}.covar1 -c 1-2 -a ${pop}.clst -o ${pop}_pca_saf.pdf
#	Rscript ~rapeek/scripts/plotPCA.R -i ${pop}.covar2 -c 1-2 -a ${pop}.clst -o ${pop}_pca_ncall.pdf
#	Rscript ~rapeek/scripts/plotPCA.R -i ${pop}.covar3 -c 1-2 -a ${pop}.clst -o ${pop}_pca_call.pdf
