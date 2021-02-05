#!/bin/bash

workdir=./probanden_liste-parts/
splitter=4

mkdir -p $workdir
rm $workdir/* 2> /dev/null

realpath ./subjects/*.nii > probanden_liste.txt
realpath ./subjects/*.img >> probanden_liste.txt
cd $workdir
split --lines=$splitter ../probanden_liste.txt
