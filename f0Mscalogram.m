function [f0Msgram, scale, step] = f0Mscalogram(insig, fs, window_NT, varargin)
%f0Mscalogram f0 modulation scalogram from periodgram
%   [f0Msgram, scale, step] = f0Mscalogram(insig, fs, window_NT, varargin)
% returns the f0M scalogram of signal insig.
% fs: sampling frequency
% shift: time shift between windows (in sec.) Determines the sampling freq.
% of the scalogram
% f0Msgram is a N-by-M function where N is the number of modulation
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

%%% f0 extraction

% Parameters for the YIN algorithm (see help yin)
undersample = kv.undersample; % undersampling for speeding up f0M calculation
ap0_thres = kv.ap0_thres;
yin_thresh = kv.yin_thresh;
% Parameters for f0 extraction artifact removing (see help remove_artifacts_FM)
maxjump = kv.maxjump;
minduration = kv.minduration;
minf = kv.minf;
maxf = kv.maxf;

P=[]; P.hop = undersample; P.sr = fs; P.minf0 = minf; P.maxf0 = maxf; P.thresh = yin_thresh;

R = yin(insig(:), P);
f0 = 440*2.^(R.f0);
f0_withnan = f0; f0_withnan(R.ap0>ap0_thres) = NaN;
f0_withnan = remove_artifacts_FM( f0_withnan, fs/undersample, maxjump, minduration, [minf maxf], [0.4 2.5], 1500, 0);
t_yin = (1:length(f0_withnan))/(fs/undersample);
fs_yin = (fs/undersample);

%%% f0M spectra
if do_silent == 0
    fprintf('calculating f0M scalograms\n');
end

clear f0Mspec
for ifreq = 1:N_fsamples
    window_length = window_NT*1/f_spectra(ifreq);
    
    % segment wavfiles into windows
    shift = 0.1;
    windows = windowing(f0_withnan, fs_yin, window_length, shift, 0);
    twindows = windowing(t_yin, fs_yin, window_length, shift, 0);
    
    Nwindows = size(windows,2);
    
    for iwindow = 1:Nwindows
        % loop on segmented files
        f0temp = windows(:,iwindow);
        ttemp = twindows(:,iwindow);
        
        %%%%%%%%%%%%%
        f0withoutnan = f0temp; f0withoutnan(isnan(f0temp))=[];
        twithoutnan = ttemp; twithoutnan=twithoutnan(1:length(f0temp)); twithoutnan(isnan(f0temp))=[];
        %%%%%%%%%%%%%%
       
        %[Efft, temp_mf] = plomb(temp,[],[1 f_spectra(ifreq)],fs,'psd'); % recall that f must contain at least two elements
        try 
            [f0Mfft, f_periodo] = plomb(f0temp,ttemp,[0.01 f_spectra(ifreq)],'psd'); %TODO change parameters
            f0Mfft=2*f0Mfft(2); % because the output is a 2-sided periodogram
        catch
            f0Mfft = nan;
            f_periodo = [0.01 f_spectra(ifreq)];
        end
        f0Mspec(iwindow+round(window_length/2/shift),ifreq) = f0Mfft; % PSD : power = mean(E(:,ichan).^2) = sum(Efft.*diff(f_spectra_intervals))
    end
    scale(ifreq) = f_spectra(ifreq);%f_periodo(2);
end

f0Msgram = f0Mspec;

f0Msgram(f0Msgram==0) = nan;

t = (1:size(f0Msgram,1))*shift;

if nargout>=3
    step.t_yin = t_yin;
    step.f0 = f0_withnan;
    step.mfb = f_spectra_intervals;
    step.flags = flags;
    step.kv = kv;
    step.t = t;
    step.scale = scale;
end

end

