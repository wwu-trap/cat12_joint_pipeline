#!/bin/bash

# For help execute ./check.sh --help
# Author: Kelvin Sarink <k.sarink@uni-muenster.de>

needed_files="/PROBANDENID.nii
/label/catROI_PROBANDENID.mat
/label/catROI_PROBANDENID.xml
/label/catROIs_PROBANDENID.mat
/label/catROIs_PROBANDENID.xml
/mri/iy_PROBANDENID.nii
/mri/mwp1PROBANDENID.nii
/mri/mwp2PROBANDENID.nii
/mri/p0PROBANDENID.nii
/mri/rp1PROBANDENID_rigid.nii
/mri/rp2PROBANDENID_rigid.nii
/mri/s10mwp1PROBANDENID.nii
/mri/s12mwp1PROBANDENID.nii
/mri/s8mwp1PROBANDENID.nii
/mri/wj_PROBANDENID.nii
/mri/wmPROBANDENID.nii
/mri/wmiPROBANDENID.nii
/mri/y_PROBANDENID.nii
/report/cat_PROBANDENID.mat
/report/cat_PROBANDENID.xml
/report/catlog_PROBANDENID.txt
/report/catreport_PROBANDENID.pdf
/report/catreportj_PROBANDENID.jpg
/surf/lh.central.PROBANDENID.gii
/surf/lh.depth.PROBANDENID
/surf/lh.fractaldimension.PROBANDENID
/surf/lh.gyrification.PROBANDENID
/surf/lh.pbt.PROBANDENID
/surf/lh.sphere.PROBANDENID.gii
/surf/lh.sphere.reg.PROBANDENID.gii
/surf/lh.thickness.PROBANDENID
/surf/rh.central.PROBANDENID.gii
/surf/rh.depth.PROBANDENID
/surf/rh.fractaldimension.PROBANDENID
/surf/rh.gyrification.PROBANDENID
/surf/rh.pbt.PROBANDENID
/surf/rh.pial.PROBANDENID.gii
/surf/rh.sphere.PROBANDENID.gii
/surf/rh.sphere.reg.PROBANDENID.gii
/surf/rh.thickness.PROBANDENID
/surf/rh.white.PROBANDENID.gii
/surf/s12.mesh.thickness.resampled_32k.PROBANDENID.dat
/surf/s12.mesh.thickness.resampled_32k.PROBANDENID.gii
/surf/s15.mesh.thickness.resampled_32k.PROBANDENID.dat
/surf/s15.mesh.thickness.resampled_32k.PROBANDENID.gii
/surf/s20.mesh.depth.resampled_32k.PROBANDENID.dat
/surf/s20.mesh.depth.resampled_32k.PROBANDENID.gii
/surf/s20.mesh.fractaldimension.resampled_32k.PROBANDENID.dat
/surf/s20.mesh.fractaldimension.resampled_32k.PROBANDENID.gii
/surf/s20.mesh.gyrification.resampled_32k.PROBANDENID.dat
/surf/s20.mesh.gyrification.resampled_32k.PROBANDENID.gii
/surf/s20.mesh.thickness.resampled_32k.PROBANDENID.dat
/surf/s20.mesh.thickness.resampled_32k.PROBANDENID.gii
/surf/s25.mesh.depth.resampled_32k.PROBANDENID.dat
/surf/s25.mesh.depth.resampled_32k.PROBANDENID.gii
/surf/s25.mesh.fractaldimension.resampled_32k.PROBANDENID.dat
/surf/s25.mesh.fractaldimension.resampled_32k.PROBANDENID.gii
/surf/s25.mesh.gyrification.resampled_32k.PROBANDENID.dat
/surf/s25.mesh.gyrification.resampled_32k.PROBANDENID.gii
"

if [ $# -eq 0 ]; then
    datadir='./';
    patient_list=`ls -1 $datadir | grep .nii`
elif [ $# -eq 1 ]; then
    if [ $1 == "--help" ]; then
        echo "This tool checks whether all files of the cjp8 exist (58 excluding or 59 including input nifti file.
Syntax:
    $ ./check.sh # checks the current dir, list of patients is derived from input nifti files
    $ ./check.sh ./data/ # checks dir ./data/, list of patients is derived from input nifti files
    $ ./check.sh ./data/ patients_list.txt # checks dir ./data/, list of patients is derived from patients_list.txt (may include .nii at end)"
        exit 0
    fi

    datadir=$1;
    patient_list=`ls -1 $datadir | grep .nii`
else
    datadir=$1;
    patient_list=`cat $2`
fi

for IDpath in $patient_list; do
    ID=`basename $IDpath | sed 's/.nii//g'`;
    files=0
    for generic_file in $needed_files; do
        idFile=$datadir/`echo $generic_file | sed "s/PROBANDENID/$ID/g"`;
        if [ -f "$idFile" ]; then
            files=$((files + 1));
        fi
    done
    echo $ID,$files
done
