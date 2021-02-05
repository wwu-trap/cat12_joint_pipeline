[ -z "$1" ] && exit 1
# Change this according to version of pipeline!
spmdir="/home/d/d_grot03/applications/standalone_spm12_v7771_cat12_v1742-long_mcr93/"
spmolddir="/opt/applications/spm12_v7771_cat12_v1742-long/"
mcrdir="/home/d/d_grot03/applications/mcr/v93"

# if more than 2 parameters (modality and at least 2 images), it's longitudinal
if [[ $# -gt 2 ]]; then intParam=$1
	shift
	modality=adjust_input_long
        theJob=cat12_complete_joint_pipeline_longitudinal.mat
        echo Using longitudinal pipeline.... $@
# otherwise it's Kelvins stuff
else
    modality=adjust_input
    theJob=cat12_complete_joint_pipeline.mat
    intParam=""
    echo Using regular pipeline.... $@
fi

nifti=`realpath $1`
id=`basename $nifti | sed 's/\.\(img\|nii\)$//g'`
timestamp=`date +'%Y-%m-%d_%H-%M-%S'`
parentdir="$(dirname $(dirname "$1"))"
workingdir="${parentdir}/workdir/${id}_$timestamp"
mkdir -p $workingdir
cd $workingdir

export MCR_INHIBIT_CTF_LOCK=1

batchfilename=$workingdir/${id}-spm12batch.mat
#Create SPM12 batch 
${spmdir}/run_spm12.sh \
${mcrdir} \
${modality} \
${spmdir}/${theJob} \
$batchfilename \
$(realpath $@) \
${spmolddir} \
${intParam} &> ./adjusting.log;

#Execute SPM12 batch
${spmdir}/run_spm12.sh \
${mcrdir} \
batch $batchfilename &> ./spm12.log
