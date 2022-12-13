#!/bin/bash

outputFile="output-orig.dat"
subdir='./data/'
jobIds_timelimit=`cat $outputFile | grep "DUE TO TIME LIMIT" | cut -d ' ' -f 5`
jobIds_oom=`cat $outputFile | grep oom-kill | cut -d ' ' -f 9 | sed 's/.batch//g'`

for jobId in `echo $jobIds_timelimit $jobIds_oom | sed 's/ /\n/g' | sort | uniq`; do 
    arrayId=`seff $jobId | grep "Array Job" | cut -d _ -f 2` || echo "No Jobid: ${jobId}";
    partsdir="./probanden_liste-parts" ;
    partsfile=`ls -1 $partsdir | sed -n "${arrayId}p"`;
    for nitfipath in `cat $partsdir/$partsfile`; do 
        patientId=`basename $nitfipath | sed 's/.nii//g'`;
        echo $patientId;
        find $subdir -iname "*$patientId*" -not -iname "$patientId.nii" ;#-delete &
    done
done

wait
