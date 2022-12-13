function make_cjp8(baseFolder)

if ~strcmp(version('-release'),'2019a')
    warning('You should provide Matlab R2019a! Not Safe here, bye.')
    exit(1);
end

restoredefaultpath
addpath(baseFolder)
addpath(genpath([baseFolder filesep 'toolbox' filesep 'cat12']));
spm('fmri');
close all
cd([baseFolder filesep 'config']);
disp('Running make standalone. This will take a while, grap a coffee!');
spm_make_standalone;
quit(0);

