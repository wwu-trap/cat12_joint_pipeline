#!/bin/bash
 
#SBATCH --export=NONE               # Start with a clean environment
#SBATCH --array=1-2                 # number of jobs here = number of files in $partsdir
#SBATCH --nodes=1                   # the number of nodes you want to reserve
#SBATCH --ntasks-per-node=4        # the number of CPU cores per node
#SBATCH --mem=32G                   # how much memory is needed per node (units can be: K, M, G, T)
#SBATCH --partition=normal          # on which partition to submit the job
#SBATCH --time=24:00:00             # the max wallclock time (time limit your job will run)
 
#SBATCH --job-name=[NameForJob]-cjp_v0010         # the name of your job
#SBATCH --output=output-orig.dat         # the file where output is written to (stdout & stderr)
#SBATCH --mail-type=ALL             # receive an email when your job starts, finishes normally or is aborted
#SBATCH --mail-user=[someMail @ uni-muenster.de] # your mail address
 
# START THE APPLICATION
partsdir="/path/to/study/probanden_liste-parts/"
partsfile=`ls -1 $partsdir | sed -n "${SLURM_ARRAY_TASK_ID}p"`


#for niftis in `cat $partsdir/$partsfile`; do
while read niftis
do	/path/to/cjp8-scripts/preprocess-nifti.sh $niftis & 
	done <"$partsdir/$partsfile"

wait

