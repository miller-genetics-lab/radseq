#!/bin/bash

if [ ! -d "results_fst" ]; then
        echo "create results_fst"
        mkdir results_fst  ### All output goes here ###
fi
echo "directory 'results_fst' exists"
date

### infiles ###
F1=$1 ### list containing population names ###
thresh=$2 # level subsampled, i.e., 60k

# get number of files
n=$(wc -l $F1 | awk '{print $1}')

### calculate all pairwise Fst's ###
x=1
while [ $x -le $n ] # while file number is less than total number of files 
do
        y=$(( $x + 1 )) # get pair number
        while [ $y -le $n ]
        do

        pop1=$( (sed -n ${x}p $F1) )
        pop2=$( (sed -n ${y}p $F1) )
		
		# set up script header
		echo "#!/bin/bash" > ${pop1}.${pop2}_${thresh}_FST.sh
                echo "" >> ${pop1}.${pop2}_${thresh}_FST.sh
                echo "#SBATCH -o out_slurms/09fst-%j.out" >> ${pop1}.${pop2}_${thresh}_FST.sh
                echo "" >> ${pop1}.${pop2}_${thresh}_FST.sh
                
		#assumes pop SAF have been calculated (get folded SFS), uses this to calculate 2DSFS prior (.ml):
		#echo "realSFS results_folded_sfs/${pop1}_${thresh}.folded.saf.idx results_folded_sfs/${pop2}_${thresh}.folded.saf.idx > results_folded_sfs/${pop1}.${pop2}_${thresh}.folded.ml" >> ${pop1}.${pop2}_${thresh}_FST.sh
		
		# Then calculate fst binary files using calculated 2dsfs as priors jointly with all safs
		#echo "realSFS fst index results_folded_sfs/${pop1}_${thresh}.folded.saf.idx results_folded_sfs/${pop2}_${thresh}.folded.saf.idx -sfs results_folded_sfs/${pop1}.${pop2}_${thresh}.folded.ml -fstout results_fst/${pop1}.${pop2}_${thresh}.folded.fstout" >> ${pop1}.${pop2}_${thresh}_FST.sh
		
		# estimator preferable for small sample sizes: (just add "-whichFst 1" flag), makes estimate more conservative for small sample sizes
		echo "realSFS fst index results_folded_sfs/${pop1}_${thresh}.folded.saf.idx results_folded_sfs/${pop2}_${thresh}.folded.saf.idx -whichFst 1 -sfs results_folded_sfs/${pop1}.${pop2}_${thresh}.folded.ml -fstout results_fst/${pop1}.${pop2}_${thresh}.folded.fstout" >> ${pop1}.${pop2}_${thresh}_FST.sh
		
		# get the global estimate for FST
		echo "realSFS fst stats results_fst/${pop1}.${pop2}_${thresh}.folded.fstout.fst.idx > results_fst/${pop1}.${pop2}_${thresh}.folded.finalFSTout" >> ${pop1}.${pop2}_${thresh}_FST.sh
		
		sbatch -J 09fst -p high --mem=8G -t 1200 -c 1 ${pop1}.${pop2}_${thresh}_FST.sh
        y=$(( $y + 1 ))

        done

x=$(( $x + 1 ))

done


#pop1=$1
#pop2=$2


#TEST 00: SFS

#/home/mlyjones/bin/angsd_dir/misc/realSFS ${1}.saf.idx ${2}.saf.idx > ${1}.${2}.ml
#/home/mlyjones/bin/angsd_dir/misc/realSFS fst index ${1}.saf.idx ${2}.saf.idx -sfs ${1}.${2}.ml -fstout ${1}.${2}.fstout
#/home/mlyjones/bin/angsd_dir/misc/realSFS fst stats ${1}.${2}.fstout.fst.idx > ${1}.${2}.finalfstout


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
