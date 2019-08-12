#!/bin/bash
#SBATCH --mail-user=rapeek@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J compressFQ
#SBATCH -e 18_compress_fastq.%j.err
#SBATCH -o 18_compress_fastq.%j.out
#SBATCH -c 20
#SBATCH -p high
#SBATCH --time=1-20:00:00

set -e # exits upon failing command
set -v # verbose -- all lines
set -x # trace of all commands after expansion before execution

cd /home/rapeek/projects/SEQS/SOMM446/split/compressed
echo Compressing SOMM R1 R2 R3 fastq files on $(date | awk '{print $4 " " $3 $2 $6}')
lzma *.fastq
echo Compression complete at $(date | awk '{print $4 " " $3 $2 $6}')
