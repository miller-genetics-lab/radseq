#!/bin/bash
#SBATCH --mail-user=rapeek@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH -J unzip
#SBATCH -e slurms/02_unzip.err
#SBATCH -o slurms/02_unzip.out
#SBATCH -c 20
#SBATCH -p high
#SBATCH --time=4-20:00:00

set -e
set -x

#  This script will unzip all raw RAD/RAPTURE data
#       Run with
#               sbatch --mem MaxMemPerNode 02_unzip.sh

cd /home/rapeek/projects/SEQS

date

for i in SOMM446
do
cd ${i}/raw
for file in *.gz
do
newname=$(basename $file .gz)
echo "unzipping " $file " to " $newname
gunzip -f $file
#chmod a=r $newname
done
cd ../
done

date

