#!/bin/bash -l

list=$1

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ] 
do
        string="sed -n ${x}p ${list}" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1, $2}')   
        set -- $var
        c1=$1
        c2=$2

        samtools view -c ${c1}.bam)


        fi

        x=$(( $x + 1 ))

done
