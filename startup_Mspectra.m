function startup_Mspectra
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

try
    dir_AMT = Mspectra_dir_amtoolbox; % [userpath filesep 'amtoolbox-code' filesep];
catch me
    Mspectra_set_amtoolbox;
    dir_AMT = Mspectra_dir_amtoolbox;
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


end