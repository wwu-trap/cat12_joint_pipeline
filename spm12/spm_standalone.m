function spm_standalone(varargin)
% Gateway function for standalone SPM
%
% References:
%
%   SPM Standalone:  https://en.wikibooks.org/wiki/SPM/Standalone
%   MATLAB Compiler: http://www.mathworks.com/products/compiler/
%
% See also: config/spm_make_standalone.m
%__________________________________________________________________________
% Copyright (C) 2010-2017 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin
% $Id: spm_standalone.m 7372 2018-07-09 16:50:44Z guillaume $ 


if ~nargin, action = ''; else action = varargin{1}; end

if strcmpi(action,'run')
    warning('"Run" is deprecated: use "Batch".');
    action = 'batch';
end

exit_code = 0;

switch lower(action)
    
    case {'adjust_input'}
        if nargin < 5
            fprintf('Correct syntax is: adjust_input [input mat] [output mat] [input nifti] [spm dir which needs to be replaced]\n');
            exit_code = 1;
        else
            inFile = varargin{2};
            outFile = varargin{3};
            nifti = varargin{4};
            oldspmdir = varargin{5};
            
            if isfile(inFile) && ~isfile(outFile)
                job = load(inFile);
                matlabbatch = job.matlabbatch;
                matlabbatch = deepreplace(matlabbatch, oldspmdir, strcat(fullfile(spm('dir')), '/'));
                matlabbatch{1}.spm.tools.cat.estwrite.data = {strcat(nifti, ',1')};
                disp('Using the following paths in given batch with this spm installation')
                deepstrdisp(matlabbatch, '/')
                save(outFile, 'matlabbatch');
                exit(0)
            else
                fprintf('Either [input mat] does not exist or [output mat] exists already\n')
                exit_code = 1;
            end
        end
    case {'adjust_input_long'}
        if nargin < 7
            % where nifti 1 .. n are the niftis to be longitudinal
            % processed
            fprintf('Correct syntax is: adjust_input [input mat] [output mat] [input nifti 1] (...) [input nifti n] [spm dir which needs to be replaced] [short|long]\n');
            exit_code = 1;
        else
            inFile = varargin{2};
            outFile = varargin{3};
            niftis = {varargin{4:end-2}};
            oldspmdir = varargin{end-1};
            mode = varargin{end};
            
            if isfile(inFile) && ~isfile(outFile)
                job = load(inFile);
                matlabbatch = job.matlabbatch;
                matlabbatch = deepreplace(matlabbatch, oldspmdir, strcat(fullfile(spm('dir')), '/'));
                % These should be relevlant file locations / prefixes                
                LONGPREFIX = strcat(filesep,'mri',filesep,'mwmwp1r');
                SHORTPREFIX = strcat(filesep,'mri',filesep,'mwp1r');
                LHPREFIX =strcat(filesep,'surf',filesep,'lh.central.r');
                TCKPREFIX=strcat(filesep,'surf',filesep,'lh.thickness.r');
                
                switch lower(mode)
                    case {'long'}
                        matlabbatch{1}.spm.tools.cat.long.longmodel = 2;
                        outPrefix = LONGPREFIX;
                    case {'short'}
                        matlabbatch{1}.spm.tools.cat.long.longmodel = 1;
                        outPrefix = SHORTPREFIX;
                    otherwise 
                        exit_code = 1;
                        error('Unkown model option. Please use "short" for small intervalls, "long" for large intervals.');
                end
                %
                for k=1:length(niftis)
                        sub{k,1} = [niftis{k} ',1'];
                        [subjectDir{k} subjectName{k} subjectExt{k}] = fileparts(niftis{k});
                        lhcent{k,1} = strcat(subjectDir{k},LHPREFIX,subjectName{k},'.gii');
                        lhthick{k,1} = strcat(subjectDir{k},TCKPREFIX,subjectName{k});
                end
                % todo:
                % * add Rois surface stuff...
                
                % (1) segment
                matlabbatch{1}.spm.tools.cat.long.datalong.subjects{1} = sub;
                % (2) extract. add surf
                matlabbatch{2}.spm.tools.cat.stools.surfextract.data_surf = lhcent;
                % (3-5) Resample & smooth 1-3; 
                %      only for the first three resample jobs thickness is used
               for smoothy=3:5
                           matlabbatch{smoothy}.spm.tools.cat.stools.surfresamp.sample{1,1}.data_surf = lhthick;                        
               end
                % 6-11 can be omitted by using dependencies
                % ...
                % smooth 12,13,14,15 (6mm/8mm/10mm/12mm)
                for smoothy=12:15
                      for k=1:length(subjectDir)
                          matlabbatch{smoothy}.spm.spatial.smooth.data{k,1} = strcat(subjectDir{k},outPrefix,subjectName{k},'.nii,1');
                      end
                end
                % Extract Surfaces Rois
                % 16 can be done via dependency
                % 17 is thickness form seg
                matlabbatch{17}.spm.tools.cat.stools.surf2roi.cdata = lhthick; 
                disp('Using the following paths in given batch with this spm installation')
                deepstrdisp(matlabbatch, '/')
                save(outFile, 'matlabbatch');
                exit(0)
            else
                fprintf('Either [input mat] does not exist or [output mat] exists already\n')
                exit_code = 1;
                
            end
        end
    case {'','pet','fmri','eeg','quit'}
    %----------------------------------------------------------------------
        spm(varargin{:});
    
    case {'-h','--help'}
    %----------------------------------------------------------------------
        cmd = lower(spm('Ver'));
        fprintf([...
            '%s - Statistical Parametric Mapping\n',...
            'https://www.fil.ion.ucl.ac.uk/spm/\n',...
            '\n'],...
            upper(cmd));
        fprintf([...
            'Usage: %s [ fmri | eeg | pet ]\n',...
            '       %s COMMAND [arg...]\n',...
            '       %s [ -h | --help | -v | --version ]\n',...
            '\n',...
            'Commands:\n',...
            '    batch          Run a batch job\n',...
            '    script         Execute a script\n',...
            '    function       Execute a function\n',...
            '    eval           Evaluate a MATLAB expression\n',...
            '    [NODE]         Run a specified batch node\n',...
            '\n',...
            'Options:\n',...
            '    -h, --help     Print usage statement\n',...
            '    -v, --version  Print version information\n',...
            '\n',...
            'Run ''%s [NODE] help'' for more information on a command.\n'],...
            cmd, cmd, cmd, cmd);
        
    case {'-v','--version'}
    %----------------------------------------------------------------------
        spm_banner;
        
    case 'batch'
    %----------------------------------------------------------------------
        inputs = varargin(2:end);
        flg = ismember(inputs,'--silent');
        if any(flg)
            quiet = true;
            inputs = inputs(~flg);
        else
            quiet = false;
        end
        flg = ismember(inputs,'--modality');
        if any(flg)
            idx = find(flg);
            try
                modality = inputs{idx+1};
            catch
                error('Syntax is: --modality <modality>.');
            end
            inputs([idx idx+1]) = [];
        else
            modality = 'fmri';
        end
        flg = ismember(inputs,'--cmdline');
        if any(flg)
            cmdline = true;
            inputs = inputs(~flg);
        else
            cmdline = false;
        end
        spm_banner(~quiet);
        spm('defaults',modality);
        spm_get_defaults('cmdline',cmdline);
        spm_jobman('initcfg');
        if isempty(inputs)
            h = spm_jobman;
            waitfor(h,'Visible','off');
        else
            try
                spm_jobman('run', inputs{:});
            catch
                fprintf('Execution failed: %s\n', inputs{1});
                exit_code = 1;
            end
        end
        spm('Quit');
        
    case 'script'
    %----------------------------------------------------------------------
        spm_banner;
        assignin('base','inputs',varargin(3:end));
        try
            if nargin > 1
                spm('Run',varargin(2));
            else
                spm('Run');
            end
        catch
            exit_code = 1;
        end
        
    case 'function'
    %----------------------------------------------------------------------
        spm_banner;
        if nargin == 1
            fcn = spm_input('function name','!+1','s','');
        else
            fcn = varargin{2};
        end
        try
            feval(fcn,varargin{3:end});
        catch
            exit_code = 1;
        end
    
    case 'eval'
    %----------------------------------------------------------------------
        spm_banner;
        if nargin == 1
            expr = spm_input('expression to evaluate','!+1','s','');
        else
            expr = varargin{2};
        end
        try
            eval(expr);
        catch
            exit_code = 1;
        end
        
    otherwise % cli
    %----------------------------------------------------------------------
        %spm('defaults','fmri');
        %spm_get_defaults('cmdline',true);
        spm_jobman('initcfg');
        try
            spm_cli(varargin{:});
        catch
            exit_code = 1;
        end
        
end

%-Display error message and return exit code (or use finish.m script)
%--------------------------------------------------------------------------
if exit_code ~= 0
    err = lasterror;
    msg{1} = err.message;
    if isfield(err,'stack')
        for i=1:numel(err.stack)
            if err.stack(i).line
                l = sprintf(' (line %d)',err.stack(i).line);
            else
                l = '';
            end
            msg{end+1} = sprintf('Error in %s%s',err.stack(i).name,l);
        end
    end
    fprintf('%s\n',msg{:});
    
    exit(exit_code);
end


%==========================================================================
function spm_banner(verbose)
% Display text banner
if nargin && ~verbose, return; end
[vspm,rspm] = spm('Ver');
tlkt = ver(spm_check_version);
if isdeployed, mcr = ' (standalone)'; else mcr = ''; end
fprintf('%s, version %s%s\n',vspm,rspm,mcr);
fprintf('%s, version %s\n',tlkt.Name,version);
spm('asciiwelcome');
