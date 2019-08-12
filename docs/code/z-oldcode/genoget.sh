#!/bin/sh

list=$1
output=$2

~/bin/angsd -bam $list  -GL 1 -out $output -doMaf 2 -minInd 20 -doMajorMinor 1 -SNP_pval 0.000001 -doGeno 4 -doPost 2 -postCutoff 0.95 -minMaf 0.005 -doCounts 1 -dumpCounts 1

