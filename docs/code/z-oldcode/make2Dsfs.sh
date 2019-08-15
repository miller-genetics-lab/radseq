#!/bin/bash -l

### JOINT 2D SFS SPECTRA BETWEEN TWO POPULATIONS ###

### Step 1 ### Match SFS files for common sites and get matching position files ###
	awk 'FNR==NR {x[$1"_"$2]=NR; next} x[$1"_"$2] {print x[$1"_"$2]; print FNR > "/dev/stderr"}' [Pop_1]_rf.saf.pos [Pop_2]_rf.saf.pos > [Pop_1].pos 2> [Pop_2].pos


### Step 2 ### Filter SFS files of populations for matching subset of sites#####
	### no.indv = total number of individuals in the population
	### no.sites = number of sites in unfiltered "pos" file (i.e. [Pop_1]_rf.saf.pos), can be obtained by "wc -l" of pos file
	### no.common.sites = number of sites in the filtered (matched) pos file (i.e. [Pop_1].pos), can be obtained by "wc -l" of pos file

	~/ngsTools/ngsUtils/GetSubSfs -infile [Pop_1]_rf.saf -posfile [Pop_1].pos -nind [no.indv] -nsites [no.sites] -len [no.common.sites] -outfile [Pop_1]_fix.saf
	~/ngsTools/ngsUtils/GetSubSfs -infile [Pop_2]_rf.saf -posfile [Pop_2].pos -nind [no.indv] -nsites [no.sites] -len [no.common.sites] -outfile [Pop_2]_fix.saf

### Step 3 ### Build joint 2DSFS spectra (i.e. matrix) & Plot ###

	~/ngsTools/ngsPopGen/ngs2dSFS -postfiles [Pop_1]_fix.saf [Pop_2]_fix.saf -outfile [Pop_12]_2DSFS -relative 0 -nind [no.indv_Pop_1] [no.indv_Pop_2] -nsites [no.common.sites] -maxlike 1
	Rscript --vanilla --slave ~/ngsTools/ngsPopGen/scripts/plot2dSFS.R [Pop_12]_2DSFS [Pop_12]_2DSFS.pdf Pop_1 Pop_2


### Step 4 ### Build index for calling outlier loci ###
	
	### Step 4A ### Transform binary saf files to tab delimited plaint txt ###

	Rscript --vanilla --slave ~/R_SCRIPTS/read_saf.R [Pop_1]_fix.saf [no.indv_Pop_1] [no.sites] [Pop_1]_fix.saf.txt
	Rscript --vanilla --slave ~/R_SCRIPTS/read_saf.R [Pop_2]_fix.saf [no.indv_Pop_2] [no.sites] [Pop_2]_fix.saf.txt

	### Step 4B ### Build index ###

	python ~/PYTHON_SCRIPTS/buildindex2dsfs.py [Pop_1]_fix.saf.txt [Pop_2]_fix.saf.txt [Pop_1].pos [Pop_1]_rf.saf.pos [Pop_12]_2DSFS.index
	
	
### Calculate S, He, and no. fixed differences between populations

	~/ngsTools/ngsPopGen/ngsStat -npop 2 -postfiles [Pop_1]_fix.saf [Pop_2]_fix.saf -nsites [no.sites] -iswin 1 -nind [no.indv] -outfile [Pop_12].stat -isfold 0 -islog 1 -block_size 100






