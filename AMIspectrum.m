function [AMIspec, fc, mf, step] = AMIspectrum(insig, fs, varargin)
%AMIspectrum Amplitude modulation excitation pattern
%   [AMIspec, fc, mf, step] = AMIspectrum(insig, fs, varargin)
% returns the AMi spectrum of signal insig, in excitation units (W).
% fs: sampling frequency
% AMIspec is a N-by-M function where N is the number of modulation
% frequencies (mf) and M is the number of audio frequencies (fc).
% 
% see Varnet et al. 2017 for more details
%
% Leo Varnet - 07/2023

if nargin<2
  error('%s: Too few input arguments.',upper(mfilename));
end;

if ~isnumeric(insig) 
  error('%s: insig must be numeric.',upper(mfilename));
end;

if ~isnumeric(fs) || ~isscalar(fs) || fs<=0
  error('%s: fs must be a positive scalar.',upper(mfilename));
end;

definput.import={'varnet2017'}; 
definput.importdefaults={}; 

do_silent = 1;

[flags,kv]  = ltfatarghelper({'flow','fhigh'},definput,varargin);

% defines the modulation axis
mflow  = kv.mflow;
mfhigh = kv.mfhigh;
N_fsamples = kv.modbank_Nmod; 
% f_spectra_intervals = logspace(log10(mflow), log10(mfhigh), N_fsamples+1);
% f_spectra           = logspace(log10(sqrt(f_spectra_intervals(1)*f_spectra_intervals(2))), log10(sqrt(f_spectra_intervals(end)*f_spectra_intervals(end-1))), N_fsamples);

% Number of steps in fractional octaves to go from mod_flow to mod_fhigh:
% N_octave_steps = ceil(NthOct * log10(mod_fhigh/mod_flow)/log10(2));
% mfc            = mod_flow * 2.^((0:N_octave_steps)/NthOct); % includes one extra bin (because of the ceiling)
% cutoff_oct     = mfc*2^(-.5/NthOct); % half step down
%%%

t=(1:length(insig))/fs;

%%% gammatone filtering
[gamma_responses,fc] = auditoryfilterbank(insig,fs,kv.flow,kv.fhigh);
f_bw = audfiltbw(fc);

%%% AM extraction
if do_silent == 0
    fprintf('E extraction\n');
end
E = abs(hilbert(squeeze(gamma_responses)));

Nchan = length(fc);
%%% AMi spectra
if do_silent == 0
    fprintf('calculating envelope spectra\n');
end

% using the king2019_modfilterbank function
[AMfilt, mf] = king2019_modfilterbank_updated(E,fs,'argimport',flags,kv); 

% % using the modfilterbank function
% [AMfilt_temp, mf] = modfilterbank(E,fs,fc,'argimport',flags,kv);
% AMfilt=nan(length(t),length(fc),length(mf));
% for i=1:length(AMfilt_temp)
%     AMfilt(:,i,1:size(AMfilt_temp{i},2)) = abs(AMfilt_temp{i});
% end

AMrms = squeeze(sqrt(mean(AMfilt.^2,1)))*sqrt(2);%squeeze(rms(AMfilt,'dim',1));
DC = squeeze(mean(E,1));%squeeze(rms(E,'dim',1));
AMIspec = AMrms./(DC'*ones(1,length(mf)));%(AMrms.^2*sqrt(2))./(DC'.^2*ones(1,length(mf))); % check this line
AMIspec = AMIspec';

if nargout>3
    step.t = t;
    step.f_bw = f_bw;
    step.gamma_responses = gamma_responses;
    step.E = E;
    step.mf = mf;
    step.AMrms = AMrms';
    step.DC = DC;
end

end
