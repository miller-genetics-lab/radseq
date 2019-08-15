#!/bin/bash

#SBATCH --mail-user=rapeek@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J pcAngsd
#SBATCH -e slurms/07_pcAngsd.%j.err
#SBATCH -o slurms/07_pcAngsd.%j.out
#SBATCH -c 20
#SBATCH -p high
#SBATCH --time=5-20:00:00

set -e # exits upon failing command
set -v # verbose -- all lines
set -x # trace of all commands after expansion before execution

# run script with
#       sbatch --mem MaxMemPerNode 07_pcAngsd.sh bamlistNAME

# set up directories
pop="SOMM446"
#code_dir="/home/rapeek/projects/SEQS/${pop}/code"
data_dir="/home/rapeek/projects/SEQS/${pop}"

cd ${data_dir}

# make results folder
mkdir -p results_pca

# move to bams folder
cd ${data_dir}/bams

echo "Starting Job: "
date

# specify bamlist
bamlist=$1

nInd=$(wc ${data_dir}/bamlists/${bamlist}.bamlist | awk '{print $1}')
#minInd=$[$nInd/2]
minInd=1

# PCAngsd (http://www.popgen.dk/software/index.php/PCAngsd)

## First generate genotype likelihoods in Beagle format using angsd
angsd -bam ${data_dir}/bamlists/${bamlist}.bamlist -out ${data_dir}/results_pca/${bamlist}_genolikes -doGlf 2 -doMajorMinor 1 -minMaf 0.05 -doMaf 2 -minInd ${minInd} -minMapQ 30 -minQ 20 -SNP_pval 1e-9 -GL 1 -nThreads 16 -sites ${data_dir}/bait_lengths.txt

## then estimate covariance matrix using PCAngsd
python ~/programs/pcangsd/pcangsd.py -beagle ${data_dir}/results_pca/${bamlist}_genolikes.beagle.gz -o ${data_dir}/results_pca/${bamlist}_pca -threads 16


