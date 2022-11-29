#!/bin/bash

# For help execute ./check.sh --help
# Author: Kelvin Sarink <k.sarink@uni-muenster.de>

needed_files="/label/catROI_PATIENTID.mat
/label/catROI_PATIENTID.xml
/label/catROIs_PATIENTID.mat
/label/catROIs_PATIENTID.xml
/mri/iy_PATIENTID.nii
/mri/mwp1PATIENTID.nii
/mri/mwp2PATIENTID.nii
/mri/p0PATIENTID.nii
/mri/rp1PATIENTID_rigid.nii
/mri/rp2PATIENTID_rigid.nii
/mri/s10mwp1PATIENTID.nii
/mri/s12mwp1PATIENTID.nii
/mri/s8mwp1PATIENTID.nii
/mri/wj_PATIENTID.nii
/mri/wmPATIENTID.nii
/mri/wmiPATIENTID.nii
/mri/y_PATIENTID.nii
/report/cat_PATIENTID.mat
/report/cat_PATIENTID.xml
/report/catlog_PATIENTID.txt
/report/catreport_PATIENTID.pdf
/report/catreportj_PATIENTID.jpg
/surf/lh.central.PATIENTID.gii
/surf/lh.depth.PATIENTID
/surf/lh.fractaldimension.PATIENTID
/surf/lh.gyrification.PATIENTID
/surf/lh.pbt.PATIENTID
/surf/lh.sphere.PATIENTID.gii
/surf/lh.sphere.reg.PATIENTID.gii
/surf/lh.thickness.PATIENTID
/surf/rh.central.PATIENTID.gii
/surf/rh.depth.PATIENTID
/surf/rh.fractaldimension.PATIENTID
/surf/rh.gyrification.PATIENTID
/surf/rh.pbt.PATIENTID
/surf/rh.pial.PATIENTID.gii
/surf/rh.sphere.PATIENTID.gii
/surf/rh.sphere.reg.PATIENTID.gii
/surf/rh.thickness.PATIENTID
/surf/rh.white.PATIENTID.gii
/surf/s12.mesh.thickness.resampled_32k.PATIENTID.dat
/surf/s12.mesh.thickness.resampled_32k.PATIENTID.gii
/surf/s15.mesh.thickness.resampled_32k.PATIENTID.dat
/surf/s15.mesh.thickness.resampled_32k.PATIENTID.gii
/surf/s20.mesh.depth.resampled_32k.PATIENTID.dat
/surf/s20.mesh.depth.resampled_32k.PATIENTID.gii
/surf/s20.mesh.fractaldimension.resampled_32k.PATIENTID.dat
/surf/s20.mesh.fractaldimension.resampled_32k.PATIENTID.gii
/surf/s20.mesh.gyrification.resampled_32k.PATIENTID.dat
/surf/s20.mesh.gyrification.resampled_32k.PATIENTID.gii
/surf/s20.mesh.thickness.resampled_32k.PATIENTID.dat
/surf/s20.mesh.thickness.resampled_32k.PATIENTID.gii
/surf/s25.mesh.depth.resampled_32k.PATIENTID.dat
/surf/s25.mesh.depth.resampled_32k.PATIENTID.gii
/surf/s25.mesh.fractaldimension.resampled_32k.PATIENTID.dat
/surf/s25.mesh.fractaldimension.resampled_32k.PATIENTID.gii
/surf/s25.mesh.gyrification.resampled_32k.PATIENTID.dat
/surf/s25.mesh.gyrification.resampled_32k.PATIENTID.gii
"

if [ $# -eq 0 ]; then
    datadir='./';
    patient_list=$(ls -1 $datadir | grep .nii)
elif [ $# -eq 1 ]; then
    if [ "$1" == "--help" ]; then
        echo "This tool checks whether all files of the cjp8 exist (58 excluding or 59 including input nifti file.
Syntax:
    $ ./check.sh # checks the current dir, list of patients is derived from input nifti files
    $ ./check.sh ./data/ # checks dir ./data/, list of patients is derived from input nifti files
    $ ./check.sh ./data/ patients_list.txt # checks dir ./data/, list of patients is derived from patients_list.txt (may include .nii at end)"
        exit 0
    fi

    datadir=$1;
    patient_list=$(ls -1 "$datadir" | grep .nii)
else
    datadir=$1;
    patient_list=$(cat "$2")
fi

for IDpath in $patient_list; do
    ID=$(basename "$IDpath" | sed 's/.nii//g');
    files=0
    for generic_file in $needed_files; do
        idFile=$datadir/"${generic_file//PATIENTID/$ID}"
        if [ -f "$idFile" ]; then
            files=$((files + 1));
        fi
    done
    echo "$ID","$files"
done
