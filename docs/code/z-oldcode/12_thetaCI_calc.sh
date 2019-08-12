#!/bin/bash -l
#SBATCH -o 12_thetaCI_calc-%j.out
ls RAD_thetas_r1/*pestPG | sed 's/.thetas.gz.pestPG//g' | sed 's:RAD_thetas_r1/::g' > thetalist_r1
echo -e "#Pop\tTw\tTp\tTd\tTotal_sites\tTw/site\tTp/site" > RAD_thetas_r1/RAD_thetas_r1.txt
wc=$(wc -l thetalist_r1 | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p thetalist_r1" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        c1=$1

	var2=$(sed 1d RAD_thetas_r1/${c1}.thetas.gz.pestPG | awk '{ Tw += $4 }; { Tp += $5 }; { Td += $9 }; { sites += $14 }; END { print Tw,Tp,Td,sites }')
	set -- $var2
	Tw=$1
	Tp=$2
	Td=$3
	sites=$4

	Tws=$(echo "scale=6;$Tw/$sites" | bc)
	Tps=$(echo "scale=6;$Tp/$sites" | bc)

	echo -e "$c1\t$Tw\t$Tp\t$Td\t$sites\t$Tws\t$Tps" >> RAD_thetas_r1/RAD_thetas_r1.txt
        
	x=$(( $x + 1 ))

done

##need to get ms sim CI values
echo -e "run\tscale\ttheta\tlo\thi" > RAD_thetas_r1/Ump_CIs.txt
echo -e "Premature\tGenome\tTp\t0.0028344065\t0.003859265" >> RAD_thetas_r1/Ump_CIs.txt
echo -e "Premature\tGenome\tTw\t0.0029073549\t0.003760179" >> RAD_thetas_r1/Ump_CIs.txt
echo -e "Premature\tGreb\tTp\t0.0000000000\t0.000613544" >> RAD_thetas_r1/Ump_CIs.txt
echo -e "Premature\tGreb\tTw\t0.0001895277\t0.001705749" >> RAD_thetas_r1/Ump_CIs.txt
echo -e "Mature\tGenome\tTp\t0.0028520635\t0.003858103" >> RAD_thetas_r1/Ump_CIs.txt
echo -e "Mature\tGenome\tTw\t0.0029462943\t0.003752356" >> RAD_thetas_r1/Ump_CIs.txt
echo -e "Mature\tGreb\tTp\t0.0013136289\t0.008800532" >> RAD_thetas_r1/Ump_CIs.txt
echo -e "Mature\tGreb\tTw\t0.0015974270\t0.009698664" >> RAD_thetas_r1/Ump_CIs.txt

rm thetalist_r1
