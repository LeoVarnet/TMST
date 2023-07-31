function Mspectra_set_YIN
% function Mspectra_set_YIN
%
% Author: Alejandro Osses, adapted by Leo Varnet (16/06/2023)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text2show = 'Please indicate the folder where YIN is located';
fprintf('\t%s\n',text2show);

target_path = uigetdir(fileparts(which(mfilename)),text2show);
target_path = [target_path filesep];

p = [];
p.script_name = 'Mspectra_dir_YIN';
p.target_path = target_path;
if ispc
    p.target_path = Convert_to_double_filesep(p.target_path);
end

text_to_write = readfile_replace('Mspectra_path_template.txt',p);

dir_file = [Mspectra_basepath 'Local' filesep];
fname_file = [dir_file p.script_name '.m'];

if exist(fname_file,'file')
    fprintf('----------------------------------------------------------------------------\n')
    fprintf('file %s exists, \npress any key to continue (will overwrite) or press ctrl+C to cancel \n',fname_file);
    fprintf('----------------------------------------------------------------------------\n')
    pause
end

if ~exist(target_path,'dir')
    mkdir(target_path);
end

fid = fopen(fname_file, 'w');
fwrite(fid, text_to_write);
fclose(fid);
%%%
