#!/bin/bash

# Usage: ./preprocess-nifti.sh <path_to_nifti>
# Author: Kelvin Sarink <k.sarink@uni-muenster.de>


# Checks:
# 1: v96 mounted? -> right version?
# 2: /in mounted ro?
# 3: /out mounted and writable
# 4: $1 is .nii{,.gz} file? (gunzip when .nii.gz after copying)
# 5 if slurm then tmp dir in out otherwise UUID


# Edit the following variables to your needs:
SPMDIR="/opt/cjp_v0008-spm12_v7771-cat12_r1720/"
BATCH_TEMPLATE="/opt/cjp8-batch-template.mat"

# BATCH_TEMPLATE_REPLACE_PATH does not need to be changed as long as you use cjp8
BATCH_TEMPLATE_REPLACE_PATH="/spm-data/Scratch/spielwiese_kelvin/cat12_joint_pipeline/cjp_v0008-spm12_v7771-cat12_r1720-modifiedcatdefaults/"


echo "--- Step 1: Prepare ---"
[ -z "$1" ] && exit 1
nifti=$(realpath "$1")
id=$(basename "$nifti" | sed 's|.nii||g')
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
workingdir="./workingdir/${id}_$timestamp"
mkdir -p "$workingdir"
workingdir=$(realpath "$workingdir")
cd "$workingdir" || exit 1


echo "--- Step 2: Preprocess ---"
#Create SPM12 batch 
batchfilename=$workingdir/${id}-cjp8_batch.mat
$SPMDIR/spm12 adjust_input "$BATCH_TEMPLATE" "$batchfilename" "$nifti" "$BATCH_TEMPLATE_REPLACE_PATH"

#Execute SPM12 batch
$SPMDIR/spm12 batch "$batchfilename"


echo "--- Step 3: Check ---"

echo "--- Step 4: Cleanup ---"


[ -z "$1" ] && exit 1

cp "$1" /out 
NIIFILE=/out/$(basename "$1")

cd /out/ || exit 1
/scripts/preprocess-nifti.sh "$NIIFILE"


