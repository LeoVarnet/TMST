function startup_TMST
% function startup_fastACI
%
% Programmed by Alejandro Osses, ENS 2021-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dir_Mspectra  = [fileparts(which(mfilename)) filesep];
addpath(dir_Mspectra);
addpath([dir_Mspectra '\legacy']);
addpath([dir_Mspectra '\Utility']);
addpath([dir_Mspectra '\Local']);
disp(['Added to path: ' dir_Mspectra])
disp(['Added to path: ' dir_Mspectra '\legacy'])
disp(['Added to path: ' dir_Mspectra '\Utility'])
disp(['Added to path: ' dir_Mspectra '\Local'])
disp(['Added to path: ' dir_Mspectra '\demo'])

try
    dir_AMT = Mspectra_dir_amtoolbox;
catch me
    Mspectra_set_amtoolbox;
    dir_AMT = Mspectra_dir_amtoolbox;
end

try
    dir_YIN = Mspectra_dir_YIN;
catch me
    Mspectra_set_YIN;
    dir_YIN = Mspectra_dir_YIN;
end

if exist(dir_AMT,'dir')
    addpath([dir_AMT filesep]);
    amt_start;
    
    addpath([ltfatbasepath 'signals' filesep]); % noise.m (pink noise)
    
    rmpath([dir_AMT 'legacy' filesep]);
else
    if ~exist('amt_start','file')
        fprintf('%s: AMT Toolbox 1.0 was not added to the path, please modify this script (%s.m)\n',upper(mfilename),mfilename);
        fprintf('    to include the correct path of the AMT toolbox in your local computer\n');
    end
end

if exist(dir_YIN,'dir')
    addpath(genpath([dir_YIN filesep]));
    disp(['Added to path: ' dir_YIN '\Local'])
else
    fprintf('%s: YIN was not added to the path, please modify this script (%s.m)\n',upper(mfilename),mfilename);
    fprintf('    to include the correct path of the YIN toolbox in your local computer\n');
end
[filepath,~,~] = fileparts(mfilename('fullpath'));
cd(filepath);
end