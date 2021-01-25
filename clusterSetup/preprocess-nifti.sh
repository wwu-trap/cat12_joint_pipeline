[ -z "$1" ] && exit 1
nifti=`realpath $1`
id=`basename $nifti | sed 's|.nii||g'`
timestamp=`date +'%Y-%m-%d_%H-%M-%S'`
workingdir="/scratch/tmp/d_grot03/for2107_long/workdir/${id}_$timestamp"
spmdir="/home/d/d_grot03/applications/standalone_spm12_v7771_cat12_v1720-long/"
spmolddir="/spm-data/Scratch/spielwiese_dominik/spm_mit_cat12_1720/spm12/"
mcrdir="/home/d/d_grot03/applications/mcr/v96"

# if more than 1 image, it's longitudinal
if [ "$#" -gt 1 ]; 
	then modality=adjust_input_long
	theJob=cat12_complete_joint_pipeline_longitudinal.mat
	echo Using longitudinal pipeline....
# otherwise it's Kelvins stuff
else
    modality=adjust_input
    theJob=cat12_complete_joint_pipeline.mat
    echo Using regular pipeline....
fi


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
${spmolddir} &> ./adjusting.log;

#Execute SPM12 batch
${spmdir}/run_spm12.sh \
${mcrdir} \
batch $batchfilename &> ./spm12.log
