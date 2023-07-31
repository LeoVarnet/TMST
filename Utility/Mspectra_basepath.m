function basepath = Mspectra_basepath
% function Mspectra_basepath

f=mfilename('fullpath');

basepath = [fileparts(f(1:end-length(mfilename)-1)) filesep]; % -1 removes filesep; fileparts goes one level up