#!/bin/bash -l


pop=$1 ### name of pop##
n1=$2  ### k number ###


x=2
while [ $x -le $n1 ] 
do
	~/bin/NGSadmix -likes ${pop}_glh.beagle -K $x -o ${pop}_admix${x}
	Rscript Admix_plot.R ${pop}_admix${x}.qopt ${pop}.info $n1
	mv Rplots.pdf ${pop}_admix${x}.pdf
	echo $x >> K
	sed -n '9p' ${pop}_admix${x}.log | cut -c11-25 >> LH

	x=$(( $x + 1 ))

done

### Plot K vs LH ###

	paste -d' ' K LH > ${pop}_admix_LH
	rm K LH 
	Rscript Admix_LH.R ${pop}_admix_LH
	mv Rplots.pdf ${pop}_admix_LH.pdf
