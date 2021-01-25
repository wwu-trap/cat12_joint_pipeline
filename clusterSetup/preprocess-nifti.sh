[ -z "$1" ] && exit 1
nifti=`realpath $1`
id=`basename $nifti | sed 's|.nii||g'`
timestamp=`date +'%Y-%m-%d_%H-%M-%S'`
workingdir="/scratch/tmp/e0trap/data/MuensterNeuroimagingCohort/cat12/cjp_v0008-spm12_v7771-cat12_r1720/workingdir/${id}_$timestamp"
mkdir -p $workingdir
cd $workingdir

export MCR_INHIBIT_CTF_LOCK=1


batchfilename=$workingdir/${id}-spm12batch.mat
#Create SPM12 batch 
/scratch/tmp/e0trap/software/cat12_joint_pipeline/ksarink-cjp_v0008-spm12_v7771-cat12_r1720/run_spm12.sh \
/scratch/tmp/e0trap/software/mcr/v96 \
adjust_input \
/scratch/tmp/e0trap/software/cat12_joint_pipeline/cat12_complete_joint_pipeline.mat \
$batchfilename \
$nifti \
/spm-data/Scratch/spielwiese_kelvin/cat12_joint_pipeline/cjp_v0008-spm12_v7771-cat12_r1720-modifiedcatdefaults/ &> ./adjusting.log;

#Execute SPM12 batch
/scratch/tmp/e0trap/software/cat12_joint_pipeline/ksarink-cjp_v0008-spm12_v7771-cat12_r1720/run_spm12.sh \
/scratch/tmp/e0trap/software/mcr/v96 \
batch $batchfilename &> ./spm12.log
