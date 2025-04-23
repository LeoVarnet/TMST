function [AMsgram, fc, scale, step] = AMscalogram(insig, fs, window_NT, varargin)
%AMspectrogram Amplitude modulation scalogram from periodgram
%   [AMsgram, fc, scale, step] = AMspectrogram(insig, fs, varargin)
% returns the AM scalogram of signal insig.
% fs: sampling frequency
% shift: time shift between windows (in sec.) Determines the sampling freq.
% of the scalogram
% AMspec is a N-by-M function where N is the number of modulation
% frequencies (step.scale) and M is the number of time samples (step.t).
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
    fprintf('calculating envelope scalograms\n');
end

for ichan=1:Nchan
    clear AMspec
    fprintf(['chan #' num2str(ichan) ' of ' num2str(Nchan) '\n'])
    for ifreq = 1:N_fsamples
        window_length = window_NT*1/f_spectra(ifreq);
        
        % segment wavfiles into windows
        shift = 0.1;
        windows = windowing(E(:,ichan), fs, window_length, shift, 1);
        Nwindows = size(windows,2);
        
        for iwindow = 1:Nwindows
            % loop on segmented files
            temp = windows(:,iwindow);
            [Efft, temp_mf] = periodogram(temp,[],[0.01 f_spectra(ifreq)],fs,'psd'); % recall that f must contain at least two elements
            Efft=2*Efft(2); % because the output is a 2-sided periodogram
            AMspec(iwindow+round(window_length/2/shift),ifreq) = Efft; % PSD : power = mean(E(:,ichan).^2) = sum(Efft.*diff(f_spectra_intervals))
        end
        scale(ifreq) = f_spectra(ifreq);
    end
    
    if exist('AMsgram')
        AMsgram = AMsgram + AMspec;
    else
        AMsgram = AMspec;
    end
    
    AMsgram(AMsgram==0) = nan;
end

t = (1:Nwindows)*shift;

if nargout>3
    step.t = t;
    step.f_bw = f_bw;
    step.gamma_responses = gamma_responses;
    step.E = E;
    step.scale = scale;
    step.fc = fc;
end

end

