#!/bin/bash
BASEDIR=$(dirname "$0")
datadir='./subjects';


# NumMatchedFiles = checkfiles (checkFile,dataDir,ID) 
checkFiles ()  {
	datadir=$2
	checkFile=$1                
	ID=$3
	files=0
	for genericFile in `cat $checkFile`; do
                        idFile=$datadir/`echo $genericFile | sed "s/PROBANDENID/$ID/g"`;
                        if [ -f "$idFile" ]; then
				files=$((files + 1));
                        fi
        done
	echo $files
}


while read proband; do 
	# longitidunial
	if [ $(echo $proband | wc -w) -gt 2 ]; then 
		modality=$(echo $proband | awk '{print $1}')
		if [[ "$modality" -eq "long" ]]; then chkFile=${BASEDIR}/check_neededfiles_long
		elif [[ "$modality" -eq "short" ]]; then chkFile=${BASEDIR}check_neededfiles_short 
		else echo $modality not valid modality && exit 1
		fi
		# do the base
		ID=`basename $(echo "$proband" | awk '{print $2}') | sed 's/.nii//g'`;
		numFiles=$(checkFiles "$chkFile""_baseline.txt" "$datadir" "$ID")
		for fu in $(echo $proband |  cut -d" " -f3-); do
			fu=`basename $fu | sed 's/.nii//g'`;
			newNum=$(checkFiles "$chkFile""_followup.txt" "$datadir" "$fu")
			numFiles=$numFiles,$newNum
		done
	# crossectional
	else	ID=`basename $proband | sed 's/.nii//g'`;
		numFiles=$(checkFiles ${BASEDIR}/check_neededfiles.txt $datadir $ID)
	fi
	echo $ID,$numFiles
done <./probanden_liste.txt

