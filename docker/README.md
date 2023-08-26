# How to use the docker container

- Mount the file you want to preprocess to `/in/`.
- Mount a directory of your choice to store the outputs to `/out/`.
- Mount an installation of [Matlab MCR](https://de.mathworks.com/help/compiler/install-the-matlab-runtime.html) v9.6 to `/opt/mcr/v96`.

## Example with Apptainer
```
apptainer run --bind <path-to-file>:/in --bind <path-to-mcr-v96>:/opt/mcr/v96 --bind <path-to-output-dir>:/out docker://ghcr.io/wwu-trap/cjp8:container-v0.2.8 /in/<file>
```

## Exit codes
| Code | Description                                                                            |
| ---: | -------------------------------------------------------------------------------------- |
|    0 | Success                                                                                |
|   11 | Wrong MCR Version                                                                      |
|   12 | Missing Argument T1w image file                                                        |
|   13 | path to T1w image does not exist                                                       |
|   14 | T1w image file must be a .nii or .nii.gz file                                          |
|   15 | Could not create output directory                                                      |
|   16 | Input NIfTI must be .nii or .nii.gz                                                    |
|   17 | spm12 adjust_input failed                                                              |
|   18 | spm12 preprocessing pipeline failed                                                    |
|   19 | Missing files in output directory                                                      |
|   20 | Final output dir already exists                                                        |
|  101 | $FINAL_OUT_DIR already exists! Not preprocessing but checking if all files are present |
