#!/bin/bash

datadir='./data';
for IDpath in `cat ./probanden_liste.txt`; do
    ID=`basename $IDpath | sed 's/.nii//g'`;
    files=0
    for genericFile in `cat check_neededfiles.txt`; do
        idFile=$datadir/`echo $genericFile | sed "s/PROBANDENID/$ID/g"`;
        if [ -f "$idFile" ]; then
            files=$((files + 1));
        fi
        # echo $idFile;
    done
    echo $ID,$files
done