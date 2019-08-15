#!/bin/bash

#SBATCH -o /home/rapeek/projects/rabo/fastq/logs/out_log_05_get_fst-%j.txt
#SBATCH -e /home/rapeek/projects/rabo/fastq/logs/err_log_05_get_fst-%j.txt
#SBATCH --mem 16G
#SBATCH -D /home/rapeek/projects/rabo/fastq/angsd_output
#OUTDIR=/home/rapeek/projects/rabo/fastq/angsd_output/Fst
#SBATCH -J get_Fst

echo "Starting Job: "
date

outdir='/home/rapeek/projects/rabo/fastq/angsd_output'

pop1=$1
pop2=$2

/home/rapeek/programs/angsd0.914/angsd/misc/realSFS ${outdir}/${1}.saf.idx ${outdir}/${2}.saf.idx > ${outdir}/${1}.${2}.ml
/home/rapeek/programs/angsd0.914/angsd/misc/realSFS fst index ${outdir}/${1}.saf.idx ${outdir}/${2}.saf.idx -sfs ${outdir}/${1}.${2}.ml -fstout ${outdir}/${1}.${2}.fstout
/home/rapeek/programs/angsd0.914/angsd/misc/realSFS fst stats ${outdir}/${1}.${2}.fstout.fst.idx > ${outdir}/${1}.${2}.Fst.txt

echo "Ending Job: "
date

