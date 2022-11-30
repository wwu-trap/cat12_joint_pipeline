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
function edumpvar ()    { for var in $@ ; do edebug "$var=${!var}" ; done }
function elog() {
    if [ "$verbosity" -ge "$verb_lvl" ]; then
        datestring=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "$datestring - $*"
    fi
}




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


