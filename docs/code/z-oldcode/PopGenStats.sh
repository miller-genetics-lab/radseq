#!/bin/bash -l

### Step 1 ### Get matching sites for all populations ###

#	~/PERL_SCRIPTS/MatchPos.pl Masu-A.saf.pos Masu-R.saf.pos

### Step 2 ### Filter SFS files of populations for matching subset of sites#####

#	~/ngsTools/ngsUtils/GetSubSfs -infile Masu-A_rf.saf -posfile Masu-A.saf.pos.out -nind 48 -nsites 9573320 -len 8817298 -outfile Masu-A_rf_fix.saf
#	~/ngsTools/ngsUtils/GetSubSfs -infile Masu-R_rf.saf -posfile Masu-R.saf.pos.out -nind 48 -nsites 9341199 -len 8817298 -outfile Masu-R_rf_fix.saf

### Step 3 ### Calculate S, He, and no. fixed differences between populations ###

	~/ngsTools/ngsPopGen/ngsStat -npop 2 -postfiles Masu-A_rf_fix.saf Masu-R_rf_fix.saf -nsites 8817298 -iswin 0 -nind 48 48 -outfile Masu_AR.stat -isfold 0 -islog 1
#	Rscript ~/R_SCRIPTS/plotSS.R -i Masu_AR.stat -o Masu_AR_stat.pdf -n And-Res

### Step 4 ### Calculate Fst between populations ###

#	~/ngsTools/ngsPopGen/ngsFST -postfiles Masu-A_rf_fix.saf Masu-R_rf_fix.saf -nind 48 48 -nsites 8817298 -outfile Masu_AR.fst3 -islog 1
#	Rscript ~/R_SCRIPTS/plotFST.R -i Masu_AR.fst3 -o Masu_AR_fst3 -p Masu-A.saf.pos.out -w 100 -s 50 -t 0.90

