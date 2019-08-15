#!/bin/bash

pop1=$1
pop2=$2


#TEST 00: SFS
#/home/mlyjones/bin/angsd_dir/misc/realSFS 


/home/mlyjones/bin/angsd_dir/misc/realSFS ${1}.saf.idx ${2}.saf.idx > ${1}.${2}.ml
/home/mlyjones/bin/angsd_dir/misc/realSFS fst index ${1}.saf.idx ${2}.saf.idx -sfs ${1}.${2}.ml -fstout ${1}.${2}.fstout
/home/mlyjones/bin/angsd_dir/misc/realSFS fst stats ${1}.${2}.fstout.fst.idx > ${1}.${2}.finalfstout


#step 1: calculate the SFS for both populations (done initially with get_saf.sh)
#../angsd -b list1 -anc *.fa -out $pop1 -dosaf 1 -gl 1
#../angsd -b list2 -anc *.fa -out $pop2 -dosaf 1 -gl 1

#step 2: calculate the 2dsfs prior
#/home/mlyjones/bin/angsd_dir/misc/realSFS ${1}.saf.idx ${2}.saf.idx > ${1}.${2}.ml -fstout ${1}.${2}.fstout
#angsd/misc/realSFS ${1}.saf.idx ${2}.saf.idx > ${1}.${2}.ml -fstout ${1}.${2}.fstout

#step 3: prepare the fst for easy window analysis
#/home/mlyjones/bin/angsd_dir/misc/realSFS fst index ${1}.saf.idx -sfs ${1}.${2}.ml -fstout ${1}.${2}.fstfinalout

#step 4: Get the global estimate
#/home/mlyjones/bin/angsd_dir/misc/realSFS fst stats ${1}.${2}.fstfinalout.fst.idx

#-> FST.unweight:0.069395 Fst.Weight:0.042349

#step 5: Sliding Window /not tested very much
#/home/mlyjones/bin/angsd_dir/misc/realSFS fst stats2 ${1}.${2}.fstfinalout.fsy.idx-win 50000 -step 10000 >slidingwindow

#print SAF
#/home/mlyjones/bin/angsd_dir/misc/realSFS print ${1}.saf.idx ${2}.saf.idx
