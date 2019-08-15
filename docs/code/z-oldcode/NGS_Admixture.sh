#!/bin/bash -l

input=$1
admixout=$2
K=$3

NGSadmix -likes $input -K $K -o $admixout -minMaf 0.05






