#!/bin/bash

# Usage: ./preprocess-nifti.sh <path_to_nifti>
# Author: Kelvin Sarink <k.sarink@uni-muenster.de>


# Edit the following variables to your needs:
path_to_compiled_spm="/scratch/tmp/e0trap/software/cat12_joint_pipeline/ksarink-cjp_v0008-spm12_v7771-cat12_r1720/"
path_to_mcr="/scratch/tmp/e0trap/software/mcr/v96"
path_to_batch_template="/scratch/tmp/e0trap/software/cat12_joint_pipeline/cat12_complete_joint_pipeline.mat"

# path_which_needs_to_be_replaced does not need to be changed as long as you use cjp8
path_which_needs_to_be_replaced="/spm-data/Scratch/spielwiese_kelvin/cat12_joint_pipeline/cjp_v0008-spm12_v7771-cat12_r1720-modifiedcatdefaults/"



# Do not edit anything below:
[ -z "$1" ] && exit 1
nifti=`realpath $1`
id=`basename $nifti | sed 's|.nii||g'`
timestamp=`date +'%Y-%m-%d_%H-%M-%S'`
workingdir="./workingdir/${id}_$timestamp"
mkdir -p $workingdir
workingdir=`realpath $workingdir`
cd $workingdir

export MCR_INHIBIT_CTF_LOCK=1


batchfilename=$workingdir/${id}-spm12batch.mat
#Create SPM12 batch 
$path_to_compiled_spm/run_spm12.sh \
$path_to_mcr \
adjust_input \
$path_to_batch_template \
$batchfilename \
$nifti \
$path_which_needs_to_be_replaced &> ./adjusting.log;

#Execute SPM12 batch
$path_to_compiled_spm/run_spm12.sh \
$path_to_mcr \
batch $batchfilename &> ./spm12.log
