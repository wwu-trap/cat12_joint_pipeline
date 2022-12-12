### Current SPM dir which needs to be replaced (adjust_input):
`/spm-data/Scratch/spielwiese_kelvin/cat12_joint_pipeline/cjp_v0008-spm12_v7771-cat12_r1720-modifiedcatdefaults/`

### How to setup the batch file
1. Setup your spm12/cat12 installation as describer in this repostory
2. copy the cat_defaults.m file to your local spm12/toolbox/cat12/ dir
3. start MATLAB 2019 (v96)
4. add the the spm12 dir to path
5. add the the cat12 dir to path recursively
6. start spm12 by executing `spm fmri` in MATLAB
7. create batch file in matlab (with custom cat_defaults.m):
   1. SPM -> Tools -> CAT12 -> CAT12: Segmentation (current release)
      1. alter `Split jobs into seperate processes` to `0`
      2. alter `Writing options.Deformation Fields` to `inverse + forward`
   2. SPM -> Tools -> CAT12 -> Surface Tools -> Extract additional surface parameters
      1. alter `Central Surfaces` by clicking on `Dependency` and choose `CAT12 [...]: Left Central Surface`
      2. alter `Cortical complexity (fractal dimension)` to `Yes`
      3. alter `Split jobs into seperate processes` to `0`
   3. SPM -> Tools -> CAT12 -> Surface Tools -> Resample and Smooth Surface Data
      1. alter `Data` by  right-clicking on `Data` and choose `Add Item` -> `(Left) Surfaces Data` 
      2. alter `Data.(Left) Surfaces Data` by clicking on `Dependency` and choose `CAT12 [...]: Left Thickness`
      3. alter `Smoothing Filter Size in FWHM` to **`12`**
      4. alter `Split jobs into seperate processes` to `0`
   4. SPM -> Tools -> CAT12 -> Surface Tools -> Resample and Smooth Surface Data
      1. alter `Data` by  right-clicking on `Data` and choose `Add Item` -> `(Left) Surfaces Data` 
      2. alter `Data.(Left) Surfaces Data` by clicking on `Dependency` and choose `CAT12 [...]: Left Thickness`
      3. alter `Smoothing Filter Size in FWHM` to **`15`**
      4. alter `Split jobs into seperate processes` to `0`
   5. SPM -> Tools -> CAT12 -> Surface Tools -> Resample and Smooth Surface Data
      1. alter `Data` by  right-clicking on `Data` and choose `Add Item` -> `(Left) Surfaces Data` 
      2. alter `Data.(Left) Surfaces Data` by clicking on `Dependency` and choose `CAT12 [...]: Left Thickness`
      3. alter `Smoothing Filter Size in FWHM` to **`20`**
      4. alter `Split jobs into seperate processes` to `0`
   6. SPM -> Tools -> CAT12 -> Surface Tools -> Resample and Smooth Surface Data
      1. alter `Data` by  right-clicking on `Data` and choose `Add Item` -> `(Left) Surfaces Data` 
      2. alter `Data.(Left) Surfaces Data` by clicking on `Dependency` and choose (choose multiple while holding CTRL and clicking on multiple files):
         1. `Extract additional [...]: Left MNI gyrification`
         2. `Extract additional [...]: Left fractal dimension`
         3. `Extract additional [...]: Left sulcal depth`
      3. alter `Smoothing Filter Size in FWHM` to **`20`**
      4. alter `Split jobs into seperate processes` to `0`
   7. SPM -> Tools -> CAT12 -> Surface Tools -> Resample and Smooth Surface Data
      1. alter `Data` by  right-clicking on `Data` and choose `Add Item` -> `(Left) Surfaces Data` 
      2. alter `Data.(Left) Surfaces Data` by clicking on `Dependency` and choose (choose multiple while holding CTRL and clicking on multiple files):
         1. `Extract additional [...]: Left MNI gyrification`
         2. `Extract additional [...]: Left fractal dimension`
         3. `Extract additional [...]: Left sulcal depth`
      3. alter `Smoothing Filter Size in FWHM` to **`25`**
      4. alter `Split jobs into seperate processes` to `0`
   8. SPM -> Spatial -> Smooth
      1. alter `Images to smooth` by clicking on `Dependency` and choose `CAT12 [...]: mwp1 Image`
      2. alter `FWHM` to **`8  8  8`**
      3. alter `Filename prefix` to **`s8`**
   9. SPM -> Spatial -> Smooth
      1. alter `Images to smooth` by clicking on `Dependency` and choose `CAT12 [...]: mwp1 Image`
      2. alter `FWHM` to **`10  10  10`**
      3.  alter `Filename prefix` to **`s10`**
   10. SPM -> Spatial -> Smooth
       1.  alter `Images to smooth` by clicking on `Dependency` and choose `CAT12 [...]: mwp1 Image`
       2.  alter `FWHM` to **`12  12  12`**
       3.  alter `Filename prefix` to **`s12`**
   11. SPM -> Tools -> CAT12 -> Surface Tools -> Extract RPO-based surface values
       1.  on `Surface Data Sample` click `specify`
       2.  alter `Surface Data Sample.(Left Sufrace Data Files)` by clicking on `Dependency` and choose (choose multiple while holding CTRL and clicking on multiple files):
           1.  `CAT12 [...]: Left Thickness`
           2.  `Extract additional [...]: Left MNI gyrification`
           3.  `Extract additional [...]: Left fractal dimension`
           4.  `Extract additional [...]: Left sulcal depth`
       3.  alter `(Left) ROI atlas files` by clicking on `Specify` and then choose all (7) atlas files

