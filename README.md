# cat12_joint_pipeline

### How to setup the cat12 Pipeline
1. Download spm12 build v7771: https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip (can be different in the future)
2. Download and extract cat12.7-RC1 build v1704: http://www.neuro.uni-jena.de/cat12/cat12_r1704.zip into the toolbox dir of spm12
3. Decide what to do with the cat_defaults.m
   1. use the vanilla version of the cat_defaults.m if you just want to execute spm12 batch files
   2. if you want to create custom spm12 batches you can use the cat_defaults.m in this repository
      1. download cat_defaults-joint_pipeline.m 
      2. rename to cat_defaults.m
      3. replace file in spm12/toolbox/cat12/cat_defaults.m
      4. it is recommended to use a vanilla version of cat12 when executing the batch on the cluster
4. compile spm12
   1. start MATLAB (we use R2019a - v96)
   2. add spm12 dir to path
   3. add cat12 dir to path (recursively)
   4. replace spm_standalone.m from this repo in spm12 dir and add the deep*.m files to the spm12 dir
      1. if not using spm12 v7487 please inspect the differences from the two files. 
      2. the only difference should be the switch case {'adjust_input'} which will be used to alter the input file from the spm12 batch
      3. you can also just put this into the spm_standalone.m of your spm12 instance
   5. start spm12 by entering `spm fmri` and close the spm12 guis again
   6. cd to spm12/config dir
   7. execute spm_make_standalone in matlab
5. 
