#!/bin/bash -l

### JOINT 2D SFS SPECTRA BETWEEN TWO POPULATIONS ###

### Step 1 ### Match SFS files for common sites and get matching position files ###
	awk 'FNR==NR {x[$1"_"$2]=NR; next} x[$1"_"$2] {print x[$1"_"$2]; print FNR > "/dev/stderr"}' TK-A_rf.saf.pos TK-R_rf.saf.pos > TK-A_rf_fix.saf.pos 2> TK-R_rf_fix.saf.pos


### Step 2 ### Filter SFS files of populations for matching subset of sites#####
	### no.indv = total number of individuals in the population
	### no.sites = number of sites in unfiltered "pos" file (i.e. [Pop_1]_rf.saf.pos), can be obtained by "wc -l" of pos file
	### no.common.sites = number of sites in the filtered (matched) pos file (i.e. [Pop_1].pos), can be obtained by "wc -l" of pos file

	~/ngsTools/ngsUtils/GetSubSfs -infile TK-A_rf.saf -posfile TK-A_rf_fix.saf.pos -nind 26 -nsites 4798659 -len 4797618 -outfile TK-A_rf_fix.saf
	
	~/ngsTools/ngsUtils/GetSubSfs -infile TK-R_rf.saf -posfile TK-R_rf_fix.saf.pos -nind 26 -nsites 4798513 -len 4797618 -outfile TK-R_rf_fix.saf

### Step 3 ### Build joint 2DSFS spectra (i.e. matrix) & Plot ###

	~/ngsTools/ngsPopGen/ngs2dSFS -postfiles TK-A_rf_fix.saf TK-R_rf_fix.saf -outfile TK-AR_2DSFS -relative 0 -nind 26 26 -nsites 4797618 -maxlike 1
	
	Rscript --vanilla --slave ~/ngsTools/ngsPopGen/scripts/plot2dSFS.R TK-AR_2DSFS TK-AR_2DSFS.pdf TK-A TK-R


### Step 4 ### Build index for calling outlier loci ###
	
	### Step 4A ### Transform binary saf files to tab delimited plaint txt ###

	Rscript --vanilla --slave ~/R_SCRIPTS/read_saf.R TK-A_rf_fix.saf 26 4797618 TK-A_rf_fix.saf.txt
	
	Rscript --vanilla --slave ~/R_SCRIPTS/read_saf.R TK-R_rf_fix.saf 26 4797618 TK-R_rf_fix.saf.txt

	### Step 4B ### Build index ###

	python ~/PYTHON_SCRIPTS/buildindex2dsfs.py TK-A_rf_fix.saf.txt TK-R_rf_fix.saf.txt TK-A_rf_fix.saf.pos TK-A_rf.saf.pos TK-AR_2DSFS.index
	
