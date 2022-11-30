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
    if [ "$verbosity" -ge "${verb_lvl:-0}" ]; then
        datestring=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "$datestring - $*"
    fi
}


function cleanup_and_exit () {
    enotify "### Cleanup ###"

    if [[ "$1" -eq 0 ]]; then
        if [ -z "$KEEP_BATCH_FILE_ON_FINISH" ]; then
            rm -rf "$BATCH_FILE"
        fi
        rm -rf "$PATH_TO_T1_NIFTI"
    elif [ -n "$DELETE_OUTPUT_ON_ERROR" ] && [[ "$1" -gt 0 ]] && [ -n "$OUT_DIR" ]; then
        einfo "Deleting ${OUT_DIR} because of set var DELETE_OUTPUT_ON_ERROR"
        rm -rf "${OUT_DIR}"
    fi
    exit "$1"
}


enotify "### Step 1: Prepare ###"

# Check mounts and arguements
if [[ ! $(grep -c "<version>9.6" /opt/mcr/v96/VersionInfo.xml 2> /dev/null) -gt 0 ]]; then
    eerror "Wrong MCR Version - Please download, install and mount MATLAB MCR v96 to /opt/mcr/v96/"
    cleanup_and_exit 11
else
    edebug "Found MATLAB MCR v96"
fi

if [ -z "$1" ]; then
    eerror "Missing argument: please provide path to T1w image file!"
    cleanup_and_exit 12
fi
if [ ! -f "$1" ]; then
    eerror "Error in argument: path to T1w image file does not exist!"
    cleanup_and_exit 13
fi
if [[ "$1" != *".nii" ]] && [[ "$1" != *".nii.gz" ]] || [[ "$1" != "/in/"* ]]; then
    eerror "Error in argument: T1w image file must be a .nii or .nii.gz file and in /in/ dir!"
    cleanup_and_exit 14
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
einfo "Output directory: $OUT_DIR"

# Create directory in /out/
if ! mkdir "$OUT_DIR"; then
    eerror "Could not write to /out/ and create output directory! Please check of /out/ is mounted correctly."
    cleanup_and_exit 15
fi

# Copy input und gunzip if needed
if [[ "$1" == *".nii" ]]; then
    cp "$1" "$PATH_TO_T1_NIFTI"
elif [[ "$1" == *".nii.gz" ]]; then
    einfo "Gunzip .nii.gz"
    gunzip -c "$1" > "$PATH_TO_T1_NIFTI"
else
    eerror "Input NIfTI must be .nii or .nii.gz!"
    cleanup_and_exit 16
fi


enotify "### Step 2: Preprocess ###"

#Create SPM12 batch 
einfo "Adjusting CJP8 Batch Template"
BATCH_FILE="$OUT_DIR/${PATIENT_ID}-cjp8_batch.mat"
if ! $SPMDIR/spm12 adjust_input "$BATCH_TEMPLATE_PATH" "$BATCH_FILE" "$PATH_TO_T1_NIFTI" "$BATCH_TEMPLATE_REPLACE_PATH"; then
    cleanup_and_exit 17
fi

#Execute SPM12 batch
einfo "Starting CJP8 Preprocessing Pipeline"
if ! $SPMDIR/spm12 batch "$BATCH_FILE"; then 
    cleanup_and_exit 18
fi


enotify "### Step 3: Check ###"



cleanup_and_exit 0