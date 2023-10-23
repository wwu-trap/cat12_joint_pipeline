#!/bin/bash
dSPM="https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip"
dCAT="https://www.neuro.uni-jena.de/cat12/cat12_r1853.zip"
pipeName=cjp_v0010-spm12_v7771-cat12_r1852
batches=batch/crosssectional-v1852_enigma

if [ ! -x $1 ] | [ $# -lt 1 ]; then 
	echo "please specify MATLABR2017a executable!"
	exit 1
fi
matlabBin=$1

mkdir -p pipeline
cd pipeline
# remove old stuff
rm -r "standalone_"${pipeName} standalone $pipeName 2> /dev/null

# download stuff
if [ $2 == "-spmfolder" ]; then
	cp -r "$3" spm12/ 
	# if needed, switch off expertgui to prevent warnings
	sed -i 's|cat.extopts.expertgui = 1|cat.extopts.expertgui = 0|g' spm12/toolbox/cat12/cat_defaults.m
else
	(wget $dSPM && unzip $(basename $dSPM) && rm $(basename $dSPM)) & 
	(wget $dCAT && unzip $(basename $dCAT) && rm $(basename $dCAT))
	wait
	mv cat12 spm12/toolbox
	if [ -f  ../"$batches"/cat_defaults.m ]; then
		cp ../"$batches"/cat_defaults.m cat12/ 
	fi
fi
# setup spm
cp ../spm12/* spm12

mv spm12 $pipeName
cd ..

# compile it
$matlabBin -nodisplay -nodesktop -r "make_cjp('$(readlink -e pipeline/$pipeName)')"

mv pipeline/standalone "pipeline/standalone_"${pipeName}
cp "$batches"/*.{mat,txt} "pipeline/standalone_"${pipeName}

echo "Done. Have fun!"

