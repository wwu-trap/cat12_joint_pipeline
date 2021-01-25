#!/bin/bash
 
#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --array=1-1089 
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=32G                   # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
 
#SBATCH --job-name=mnc-cjp_v0008-long         # the name of your job
#SBATCH --output=output-orig.dat         # the file where output is written to (stdout & stderr)
#SBATCH --mail-type=ALL             # receive an email when your job starts, finishes normally or is aborted
#SBATCH --mail-user=d_grot03@uni-muenster.de # your mail address
 
# START THE APPLICATION
partsdir="/scratch/tmp/d_grot03/for2107_long/parts"
partsfile=`ls -1 $partsdir | sed -n "${SLURM_ARRAY_TASK_ID}p"`


OIFS="$IFS"
IFS=$'\n'
for niftis in `cat $partsdir/$partsfile`; do 
	/home/d/d_grot03/cjp8-scripts/preprocess-nifti.sh $niftis & 
	done
IFS="$OIFS"

wait

