#!/bin/bash -l

F1=$1
F2=$2

n1=$(wc -l ${F1}.saf.pos | awk '{print $1}')
n2=$(wc -l ${F2}.saf.pos | awk '{print $1}')

### JOINT 2D SFS SPECTRA BETWEEN TWO POPULATIONS ###

### Step 1 ### Match SFS files for common sites and get matching position files ###

	MatPos.pl ${F1}.saf.pos ${F2}.saf.pos

L=$(wc -l ${F1}.saf.pos.out | awk '{print $1}')

### Step 2 ### Filter SFS files of populations for matching subset of sites#####
	### no.indv = total number of individuals in the population
	### no.sites = number of sites in unfiltered "pos" file (i.e. [Pop_1]_rf.saf.pos), can be obtained by "wc -l" of pos file
	### no.common.sites = number of sites in the filtered (matched) pos file (i.e. [Pop_1].pos), can be obtained by "wc -l" of pos file

	~/ngsTools/ngsUtils/GetSubSfs -infile ${F1}.saf -posfile ${F1}.saf.pos.out -nind 26 -nsites $n1 -len $L -outfile ${F1}.new.saf
	~/ngsTools/ngsUtils/GetSubSfs -infile ${F2}.saf -posfile ${F2}.saf.pos.out -nind 26 -nsites $n2 -len $L -outfile ${F2}.new.saf


### Step 3 ### Build joint 2DSFS spectra (i.e. matrix) & Plot ###

	~/ngsTools/ngsPopGen/ngs2dSFS -postfiles ${F1}.new.saf ${F1}.new.saf -outfile ${F1}_${F2}.2dsfs -relative 0 -nind 48 48 -nsites $L -maxlike 1
	Rscript --vanilla --slave ~/ngsTools/ngsPopGen/scripts/plot2dSFS.R ${F1}_${F2}.2dsfs ${F1}_${F1}_2dsfs.pdf ${F1} ${F2}



### Step 4 ### Build index for calling outlier loci ###
	
	### Step 4A ### Transform binary saf files to tab delimited plaint txt ###

#	Rscript --vanilla --slave ~/R_SCRIPTS/read_saf.R Masu-A_rf_fix.saf 48 8817298 Masu-A_rf_fix.saf.txt
#	Rscript --vanilla --slave ~/R_SCRIPTS/read_saf.R Masu-R_rf_fix.saf 48 8817298 Masu-R_rf_fix.saf.txt

	### Step 4B ### Build index ###

#	python ~/PYTHON_SCRIPTS/buildindex2dsfs.py Masu-A_rf_fix.saf.txt Masu-R_rf_fix.saf.txt Masu-A.saf.pos.out Masu-A.saf.pos Masu-AR_2DSFS.index
	
	
### Calculate S, He, and no. fixed differences between populations

#	~/ngsTools/ngsPopGen/ngsStat -npop 2 -postfiles [Pop_1]_fix.saf [Pop_2]_fix.saf -nsites [no.sites] -iswin 1 -nind [no.indv] -outfile [Pop_12].stat -isfold 0 -islog 1 -block_size 100






