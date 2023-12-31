function [AMspec, fc, mf, step] = AMspectrum(insig, fs, varargin)
%AMspectrum Amplitude modulation spectrum
%   [AMspec, fc, mf, step] = AMspectrum(insig, fs, varargin)
% returns the AMa spectrum of signal insig (PSD measured in W/Hz unit).
% fs: sampling frequency
% AMspec is a N-by-M function where N is the number of modulation
% frequencies (mf) and M is the number of audio frequencies (fc).
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
f_spectra_intervals = logspace(log10(mflow), log10(mfhigh), N_fsamples+1);
f_spectra           = logspace(log10(sqrt(f_spectra_intervals(1)*f_spectra_intervals(2))), log10(sqrt(f_spectra_intervals(end)*f_spectra_intervals(end-1))), N_fsamples);

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
%%% AM spectra
if do_silent == 0
    fprintf('calculating envelope spectra\n');
end
for ichan=1:Nchan
    [Efft, mf] = periodogram(E(:,ichan),[],f_spectra,fs,'psd');
    %[Efft, mf] = plomb(E(:,ichan),t,f_spectra);
    
    Efft=2*Efft; % because the output is a 2-sided periodogram
    AMspec(:,ichan) = Efft; % PSD : power = mean(E(:,ichan).^2) = sum(Efft.*diff(f_spectra_intervals))
end

if nargout>3
    step.t = t;
    step.f_bw = f_bw;
    step.gamma_responses = gamma_responses;
    step.E = E;
    step.mf = mf;
    step.mfb = f_spectra_intervals;
end

end
