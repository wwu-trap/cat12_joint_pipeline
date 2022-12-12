# cat12_joint_pipeline

## Cross-sectional data 

### How to use the cat12 pipeline
1. setup MATLAB
   1. if you want to compile the spm12 installation use regular matlab
   2. if you want to execute the pipeline with many concurrent processes, you are advised to use the the MATLAB Runtime: https://de.mathworks.com/products/compiler/matlab-runtime.html - please use the version specified below
2. setup your spm12/cat12 installation by either downloading the precompiled version or follow the steps below
3. download the the batch template (./batch/cat12_complete_joint_pipeline.mat) 
4. create a specific batch file, derived from the batch template:<br />
   `<path_to_compiled_spm>/run_spm12.sh <path_to_mcr> adjust_input <path_to_batch_template> <path_to_new_batch> <path_to_nifti> <path_which_needs_to_be_replaced>`
   - `<path_to_mcr>`: MATLAB Runtime for version information see below
   - `<path_to_batch_template>`: batch template (./batch/crosssectional-v1720/cat12_complete_joint_pipeline.mat) 
   - `<path_to_new_batch>`: this file must not exist
   - `<path_which_needs_to_be_replaced>`: see README.md in ./batch/crosssectional-v1720/ directory
5. execute the SPM12 batch:<br />
   `<path_to_compiled_spm>/run_spm12.sh <path_to_mcr> batch <path_to_new_batch>`

### How to setup the compiled cat12 pipeline (current version: cjp_v0008-spm12_v7771-cat12_r1720)
1. download spm12 build v7771: https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip (can be different in the future)
2. download and extract cat12.7 (stable) build v1720: http://www.neuro.uni-jena.de/cat12/cat12_r1720.zip into the toolbox dir of spm12
3. add the files from the **spm12** dir in this repo to the root dir of your local spm12 installation 
4. add the files from the **cat12** and the **cat_defaults.m** from **batch/crosssectional-v1720** dir in this repo to your local spm12/toolbox/cat12/ dir
5. compile spm12
   1. start MATLAB (we use R2019a - v96)
   2. add spm12 dir to path
   3. add cat12 dir to path (recursively)
   5. start spm12 by entering `spm fmri` and close the spm12 guis again
   6. cd to spm12/config dir (in matlab)
   7. execute spm_make_standalone in matlab
   8. if the warning `Warning: A startup.m has been detected in /home/ksarink/matlab.` shows up, please make sure to delete (or move) the startup.m file during the compiling process since this file can break the compiled version

## longitudinal data 

### How to setup and compile the cat12 pipeline longitudinal (current version: cjp_v0009long-spm12_v7771-cat12_r1742) using make-script
1. Please make sure you have installed MATLAB 2017b
2. run `make_cjp9-long.sh [path to your MATLAB 2017b executable]`

### How to use the cat12 pipeline longitudinal (current version: cjp_v0009long-spm12_v7771-cat12_r1742)
Please note, that Matlab 2019 showed some issues with the longitudinal stream in compiled SPM. Matlab R2017b however works fine, so we use it.

1. Setup MATLAB 2017 (v93)
   1. if you want to compile the spm12 installation use regular matlab
   2. if you want to execute the pipeline with many concurrent processes, you are advised to use the the MATLAB Runtime: https://de.mathworks.com/products/compiler/matlab-runtime.html - please use version v96
2. setup your spm12/cat12 installation by either downloading the precompiled version or follow the steps below
3. TODO

### How to setup the compiled cat12 pipeline longitudinal (current version: cjp_v0009long-spm12_v7771-cat12_r1742)
1. Download spm12 build v7771: https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip (can be different in the future)
2. Download and extract cat12.7 (stable) build v1720: http://www.neuro.uni-jena.de/cat12/cat12_r1720.zip into the toolbox dir of spm12
3. add the files from the **spm12** dir in this repo to the root dir of your local spm12 installation
4. add the files from the **cat_defaults.m** from **batch/longitudinal-v1742/** dir in this repo to your local spm12/toolbox/cat12/ dir
5. compile spm12
   1. start MATLAB (we use R2017b - v93)
   2. add spm12 dir to path (no need to add cat12)
   5. start spm12 by entering `spm fmri` and close the spm12 guis again
   6. cd to spm12/config dir (in matlab)
   7. execute spm_make_standalone in matlab
   8. if the warning `Warning: A startup.m has been detected in /home/ksarink/matlab.` shows up, please make sure to delete (or move) the startup.m file during the compiling process since this file can break the compiled version

### How to run the compiled cat12 pipeline longitudinal (current version: cjp_v0009long-spm12_v7771-cat12_r1742)
1. Get the compiled spm and cat12 (see above)
2. Get Matlab runtime v93 (=R2017b)
   1. Linux 64bit: `wget https://ssd.mathworks.com/supportfiles/downloads/R2017b/deployment_files/R2017b/installers/glnxa64/MCR_R2017b_glnxa64_installer.zip`
   2. `unzip MCR_R2017b_glnxa64_installer.zip`
   3. `./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent`
3. Do longitudinal preprocessing:

    #Create SPM12 batch - large changes, long time
    [pathToCompiledSPM]/run_spm12.sh [pathToMCRv93] adjust_input_long [pathTo files of cat12_joint_pipeline/batch/longitudinal-v1742/cat12_complete_joint_pipeline_longitudinal.mat] \ 
    	[nameForBatchfileToGenerate] [mprage_T1.nii] ... [mprage_Tn.nii] [spm dir to replace in job] long
    
    # ... or
    #Create SPM12 batch - small changes, short time
    [pathToCompiledSPM]/run_spm12.sh [pathToMCRv93] adjust_input_long [pathTo files of cat12_joint_pipeline/batch/longitudinal-v1742/cat12_complete_joint_pipeline_longitudinal.mat] \    
        [nameForBatchfileToGenerate] [mprage_T1.nii] ... [mprage_Tn.nii] [spm dir to replace in job] short

    #Execute SPM12 batch
	[pathToCompiledSPM]/run_spm12.sh [pathToMCRv93] batch [generatedBatchFile]

See some scripts in clusterSetup for better understanding and for example how to use on Slurm Cluster
