function make_cjp(baseFolder)

if ~strcmp(version('-release'),'2017b')
    warning('You should provide Matlab R2017b! Not Safe here, bye.')
    exit(1);
end

restoredefaultpath
addpath(baseFolder)
spm('fmri');
close all
cd([baseFolder filesep 'config']);
disp('Running make standalone. This will take a while, grap a coffee!');
spm_make_standalone;
quit(0);

