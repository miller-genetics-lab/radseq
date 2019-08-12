#!/bin/bash -l

### Estimate Thetas ###

#	~/bin/angsd0.581/angsd -bam HK.list -out HK -GL 1 -doThetas 1 -doSaf 1 -pest HK.saf.ml -anc Omykiss_scflds.fasta
#	~/bin/angsd0.581/angsd -bam TK.list -out TK -GL 1 -doThetas 1 -doSaf 1 -pest TK.saf.ml -anc Omykiss_scflds.fasta

### unzip all ###

#	gunzip *.gz

### Transform theta files into binary format ###

#	~/bin/angsd0.581/misc/thetaStat make_bed HK.thetas.gz
#	~/bin/angsd0.581/misc/thetaStat make_bed TK.thetas.gz

### Calculate Tajimas's D ###

	~/bin/angsd0.581/misc/thetaStat do_stat HK.thetas.gz -nChr 88  -win 1000 -step 200 -outnames HK.outtheta3
	~/bin/angsd0.581/misc/thetaStat do_stat TK.thetas.gz -nChr 102 -win 1000 -step 200 -outnames TK.outtheta3
