#!/bin/bash

ls /home/djprince/active_projects/RunTiming_2/samples/*ss50k.bam | grep Omy | grep -v 27_D01 | grep Eel | sed 's/_ss50k//g' > Omy_Eel.bamlist
ls /home/djprince/active_projects/RunTiming_2/samples/*ss50k.bam | grep Omy | grep Ump | sed 's/_ss50k//g' > Omy_Ump.bamlist
ls /home/djprince/active_projects/RunTiming_2/samples/*ss50k.bam | grep Ots | grep Salmon | sed 's/_ss50k//g' > Ots_Salmon.bamlist
ls /home/djprince/active_projects/RunTiming_2/samples/*ss50k.bam | grep Ots | grep Puyal | sed 's/_ss50k//g' > Ots_Puyal.bamlist
ls /home/djprince/active_projects/RunTiming_2/samples/*ss50k.bam | grep Ots | grep TrinRv | sed 's/_ss50k//g' > Ots_TrinRv.bamlist
ls /home/djprince/active_projects/RunTiming_2/samples/*ss50k.bam | grep Ots | grep Ump | sed 's/_ss50k//g' > Ots_Ump.bamlist



ls *bamlist | sed 's/.bamlist//g' > tmp

wc=$(wc -l tmp | awk '{print $1}')
echo $wc
mkdir slurm_outs/
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p tmp" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1,$2,$3}')   
        set -- $var
        c1=$1
        c2=$2
        c3=$3
	
	sed -r 's/^.*_L_.*/0/g' ${c1}.bamlist | sed -r 's/^.*_E_.*/1/g' > ${c1}.ybin
	
	echo "#!/bin/bash -l" > assoc_${c1}.sh
        echo "#SBATCH -o slurm_outs/assoc_${c1}-%j.out" >> assoc_${c1}.sh
        echo "" >> assoc_${c1}.sh
	echo "/home/djprince/programs/angsd0.612/angsd -bam ${c1}.bamlist -out ${c1}_2 -yBin ${c1}.ybin -GL 1 -doMajorMinor 1 -doMaf 2 -doPost 2 -minQ 20 -minMapQ 10 -doAsso 2 -SNP_pval 1e-6" >> assoc_${c1}.sh
	
	sbatch -J djpass assoc_${c1}.sh
	rm assoc_${c1}.sh

        x=$(( $x + 1 ))
done

rm tmp

