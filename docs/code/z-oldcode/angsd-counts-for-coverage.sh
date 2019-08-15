#!/bin/bash -l
#http://www.popgen.dk/angsd/index.php/Allele_Counts

list=$1
sites=$2

/home/mlyjones/bin/angsd -bam $list -out ${list}.${sites} -MinQ 10 -minMapQ 10 -doCounts 1 -dumpCounts 2 -sites $sites

#previous minQ 20 changed to 10 to match the other files
