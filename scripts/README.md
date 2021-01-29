# Some helper scripts 
These scripts can be helpfull while you use the cat12 pipeline
## check.sh
Check if all files are created. See usage with `$ ./check.sh --help`
## preprocess-nifti.sh
Allows to quickly process a nifti when your pipeline is set up. Please adjust the variables on top of the script to your needs. Afterwards usage is easy with: `$ ./preprocess-nifti.sh <path_to_nifti>`. This script creates a working directory, derives a batch file from the template and then starts the pipeline for this nifti. Only works for one nifti file!
