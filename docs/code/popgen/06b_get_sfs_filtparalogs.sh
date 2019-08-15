#!/bin/bash -l

#mkdir results_sfs_filt

infile=$1 ### list containing population names ###
thresh=$2
ref='final_contigs_300.fa' ### reference fasta file used in alignment, IMPORTANT!!! Reference must correspond to ancestral states, if not supply a different fasta file for -anc!!! ###

n=$(wc $infile | awk '{print $1}')

#<<'Comment' # for multiline comment

### Calculate saf files and the ML estimate of the sfs using the EM algorithm for each population ###
x=1
while [ $x -le $n ] 
do

        pop=$(sed -n ${x}p $infile)

                echo "#!/bin/bash" > ${pop}_get_sfs.sh
                echo "" >> ${pop}_get_sfs.sh
		echo "#SBATCH -o out_slurms/06b_filt_sfs-%j.out" >> ${pop}_get_sfs.sh
		echo "" >> ${pop}_get_sfs.sh
		
		# if filter_paralogs has been run use this line
		echo "angsd -bam bamlists/${pop}_${thresh}_thresh.bamlist -ref $ref -anc $ref -sites bait_lengths.txt -rf results_loci/${pop}_${thresh}.loci -out results_sfs_filt/${pop}_${thresh} -GL 2 -doSaf 1 -minMapQ 10 -minQ 20" >> ${pop}_get_sfs.sh
                echo "realSFS results_sfs_filt/${pop}_${thresh}.saf.idx -maxIter 100 > results_sfs_filt/${pop}_${thresh}.sfs" >> ${pop}_get_sfs.sh
                echo "~/scripts/plotSFS.R results_sfs_filt/${pop}_${thresh}.sfs" >> ${pop}_get_sfs.sh
                
		sbatch -J rpsfs_filt -t 2880 --mem=16G -c 1 ${pop}_get_sfs.sh

        x=$(( $x + 1 ))

done

#Comment

<<Comment
### Calculate common sites and saf files for use in NGStools ###

list=$(sed 's/$/\.saf\.idx/' $infile | sed 's/^/results_sfs\//' | tr '\n' ' ')

echo "#!/bin/bash
#SBATCH -o slurm_outs/oldsaf-%j.out
realSFS print $list -oldout 1
" > oldsaf.sh

sbatch -J rapsaf -t 720 --mem=60G oldsaf.sh

zless shared.pos.gz | awk '{print $1}' | sort | uniq > common_loci.list

Comment

