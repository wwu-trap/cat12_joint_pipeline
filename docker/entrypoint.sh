#!/bin/bash

# Usage: ./preprocess-nifti.sh <path_to_nifti>
# Author: Kelvin Sarink <k.sarink@uni-muenster.de>

# Logging
colred='\033[0;31m' # Red
colgrn='\033[0;32m' # Green
colylw='\033[0;33m' # Yellow
colpur='\033[0;35m' # Purple
colrst='\033[0m'    # Text Reset

verbosity=${LOGLEVEL:-5}

### verbosity levels
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6
 
## esilent prints output even in silent mode
function esilent ()     { verb_lvl=$silent_lvl elog "$*" ;}
function enotify ()     { verb_lvl=$ntf_lvl elog "$*" ;}
function eok ()         { verb_lvl=$ntf_lvl elog "SUCCESS - $*" ;}
function ewarn ()       { verb_lvl=$wrn_lvl elog "${colylw}WARNING${colrst} - $*" ;}
function einfo ()       { verb_lvl=$inf_lvl elog "INFO ---- $*" ;}
function edebug ()      { verb_lvl=$dbg_lvl elog "${colgrn}DEBUG${colrst} --- $*" ;}
function eerror ()      { verb_lvl=$err_lvl elog "${colred}ERROR${colrst} --- $*" ;}
function ecrit ()       { verb_lvl=$crt_lvl elog "${colpur}FATAL${colrst} --- $*" ;}
function elog() {
    if [ "$verbosity" -ge "$verb_lvl" ]; then
        datestring=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "$datestring - $*"
    fi
}


enotify "### Step 1: Prepare ###"

# Check mounts and arguements
if [[ ! $(grep -c "<version>9.6" /opt/mcr/v96/VersionInfo.xml 2> /dev/null) -gt 0 ]]; then
    eerror "Wrong MCR Version - Please download, install and mount MATLAB MCR v96 to /opt/mcr/v96/"
    exit 11
else
    edebug "Found MATLAB MCR v96"
fi

if [ -z "$1" ]; then
    eerror "Missing argument: please provide path to T1w image file!"
    exit 12
fi
if [ ! -f "$1" ]; then
    eerror "Error in argument: path to T1w image file does not exist!"
    exit 13
fi
if [[ "$1" != *".nii" ]] && [[ "$1" != *".nii.gz" ]] || [[ "$1" != "/in/"* ]]; then
    eerror "Error in argument: T1w image file must be a .nii or .nii.gz file and in /in/ dir!"
    exit 14
fi

# Set variables
SPMDIR="/opt/cjp_v0008-spm12_v7771-cat12_r1720/"
BATCH_TEMPLATE_REPLACE_PATH="/spm-data/Scratch/spielwiese_kelvin/cat12_joint_pipeline/cjp_v0008-spm12_v7771-cat12_r1720-modifiedcatdefaults/"
PATIENT_ID=$(basename "$1" | sed -E 's/\.nii(\.gz)?$//g')
if [ -n "$SLURM_JOB_NAME" ] && [ -n "$SLURM_JOB_ID" ]; then
    OUT_DIR="/out/${SLURM_JOB_NAME}-${SLURM_JOB_ID}_${PATIENT_ID}"
else 
    OUT_DIR="/out/$(uuidgen)_${PATIENT_ID}"
fi
PATH_TO_T1_NIFTI="${OUT_DIR}/$(basename "$1" | sed -E 's/\.gz$//g')"
WORKING_DIR="${OUT_DIR}/workingdir/"
einfo "Output directory: $OUT_DIR"

# Create directories in /out/
if ! mkdir "$OUT_DIR"; then
    eerror "Could not create write to /out/ and create output directory!"
    exit 15
fi
mkdir "$WORKING_DIR"
if ! cd "$WORKING_DIR"; then
    eerror "Cannot cd to $WORKING_DIR - please check permissions!"
    exit 16
fi

# Copy input und gunzip if needed


# TODO:
# Copy to output/workdir
# gunzip when .nii.gz

# PATH_TO_T1_NIFTI=$(realpath "$1")


exit 0



echo "--- Step 2: Preprocess ---"
#Create SPM12 batch 
batchfilename=$WORKING_DIR/${PATIENT_ID}-cjp8_batch.mat
$SPMDIR/spm12 adjust_input "$BATCH_TEMPLATE_PATH" "$batchfilename" "$PATH_TO_T1_NIFTI" "$BATCH_TEMPLATE_REPLACE_PATH"

#Execute SPM12 batch
$SPMDIR/spm12 batch "$batchfilename"


echo "--- Step 3: Check ---"

echo "--- Step 4: Cleanup ---"


[ -z "$1" ] && exit 1

cp "$1" /out 
NIIFILE=/out/$(basename "$1")

cd /out/ || exit 1
/scripts/preprocess-nifti.sh "$NIIFILE"


