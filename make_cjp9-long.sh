#!/bin/bash
dSPM="https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip"
dCAT="http://www.neuro.uni-jena.de/cat12/cat12_r1742.zip"
pipeName=cjp_v0009-spm12_v7771-cat12_r1742

if [ ! -x $1 ] | [ $# -lt 1 ]; then 
	echo "please specify MATLABR2019a executable!"
	exit 1
fi
matlabBin=$1

mkdir -p pipeline
cd pipeline
# remove old stuff
rm -r "standalone_"${pipeName} standalone $pipeName 2> /dev/null

# download stuff
(wget $dSPM && unzip $(basename $dSPM) && rm $(basename $dSPM)) & 
(wget $dCAT && unzip $(basename $dCAT) && rm $(basename $dCAT))
wait

# setup spm
cp ../spm12/* spm12/ 
cp ../batch/v1742/cat_defaults.m cat12/ 
mv cat12 spm12/toolbox
mv spm12 $pipeName
cd ..

# compile it
$matlabBin -nodisplay -nodesktop -r "make_cjp9_long('$(readlink -e pipeline/$pipeName)')"

mv pipeline/standalone "pipeline/standalone_"${pipeName}
cp batch/v1742/*.mat batch/v1742/*.txt "pipeline/standalone_"${pipeName}

echo "Done. Have fun!"

