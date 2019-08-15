#!/bin/bash -l 

F1=$1
#F2=$2
#n=$(wc -l ${F1}.fasta | awk '{print $1}')
#E=$((${F2}*8))
#n1=$((${n}/10))
#l=$((${n1} + 1))


#split -l $l ${F1}.fasta ${F1}.fasta'_' 

~iksaglam/bin/novoindex ${F1}.index ${F1}.fasta 

#x=1
#while [ $x -le 10 ]
#do

#	string="sed -n ${x}p data"
#	str=$($string)
#
#	var=$(echo $str | awk -F"\t" '{print $1}')   
#	set -- $var
#	c1=$1	### Sample name  ###
#	
#		echo "#!/bin/bash" > ${c1}.sh
#vo* > ${F1}.novo
#		echo "" >> ${c1}.sh
#
#		echo "~iksaglam/bin/novoalign  -r E $E -t 180 -d ${F1}.index -f ${F1}.fasta_${c1} > ${F1}.novo_${c1}" >> ${c1}.sh
#		
#		sbatch --mem=16G -c 1 ${c1}.sh
#
#	x=$(( $x + 1 ))
#
#done


	cat *novo* > ${F1}.novo
		
#	IdentifyLoci3.pl ${F1}.novo > ${F1}.loci 
#	SimplifyLoci2.pl ${F1}.loci > ${F1}_simple.loci

