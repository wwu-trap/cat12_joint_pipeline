#!/bin/bash
modality=long


workdir=./probanden_liste-parts/

mkdir -p $workdir
rm $workdir/*
rm probanden_liste.txt 2> /dev/null

baseline=$(ls ./subjects/* | egrep "/[0-9].*-1_for2107.nii")
for bl in $baseline; do 
	echo .... $bl
	followup=$(echo $bl |sed 's|\-1|-2|g')
	if [ -f $followup ]; then 
		echo $modality $(realpath $bl $followup) >> probanden_liste.txt
	else echo "No followp found for $bl"
	fi
done

cd $workdir
split --lines=2 ../probanden_liste.txt
