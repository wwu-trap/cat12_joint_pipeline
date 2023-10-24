# Change this according to version of pipeline!
spmdir="/home/d/d_grot03/applications/standalone_cjp_v0010-spm12_v7771-cat12_r1852"
spmolddir="/home/dgrotegerd/code/cat12_joint_pipeline/enigma_sct_vbm/spm12_v7771_r1852"
mcrdir="/home/d/d_grot03/applications/mcr/v93"

die() {
    echo "$PROGNAME: $*"
    exit 1
}

usage() {
    if [ "$*" != "" ] ; then
        echo "Error: $*"
    fi

    cat << EOF
Usage: $PROGNAME {Options ...} {longparam} nifti1 {nifti2 ... niftiN}
<Program description>.

longparam: 				either "long" or "short" (see cat12)

Options:
-h, --help                              display this usage message and exit
-spmdir 				spmdir on actual system
-olddir					old spmdir where job / standalone was created
-mcrdir					spm runtime dir
-job					job file

$PROGNAME will start cat-joint pipeline on cluster with matlab standalone
EOF

    exit 1
}


if [[ $# -eq 0 ]]; then 
	usage "Input missing"
fi

while [[ "$1" == "-"* ]] ; do
	case "$1" in 
	-h|--help)
		usage
		;;
	-spmdir)
		spmdir=$2
		;;
	-olddir)
		spmolddir=$2
		;;
	-mcrdir)
		mcrdir=$2
		;;
	-job)
		theJob=$2
		;;
	-*)
        	usage "Unknown option '$1'"
	        ;;
	esac
	shift
	shift
done

# if more than 2 parameters (modality and at least 2 images), it's longitudinal
if [[ $# -gt 2 ]]; then intParam=$1
	shift
	modality=adjust_input_long
	[ -z "$theJob" ] && theJob=cat12_complete_joint_pipeline_longitudinal.mat
        echo Using longitudinal pipeline.... $@
# otherwise it's Kelvins stuff
else
    modality=adjust_input
    [ -z "$theJob" ] && theJob=cat12_enigma-sct_pipeline.mat
    intParam=""
    echo Using enigma pipeline.... $@
fi

# Checks
for f in $@; do
	if [[ ! -f $f ]]; then usage "Input $f does not exist"; fi
done
[  ! -d $spmdir ] && usage "SPM Dir $spmdir does not exist"
[  ! -d $mcrdir ] && usage "Matlab Runtime $mcrdir does not exist"
[  ! -f ${spmdir}/${theJob} ] && usage "Job file ${spmdir}/${theJob} does not exist"


nifti=`realpath $1`
id=`basename $nifti | sed 's/\.\(img\|nii\)$//g'`
timestamp=`date +'%Y-%m-%d_%H-%M-%S'`
parentdir="$(dirname $(dirname "$nifti"))"
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

echo Logfile: $(pwd)/spm12.log 
