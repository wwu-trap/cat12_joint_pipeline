#!/bin/bash

workdir=./probanden_liste-parts/

mkdir -p $workdir
rm $workdir/*

realpath ./data/* > probanden_liste.txt
cd $workdir
split --lines=2 ../probanden_liste.txt
