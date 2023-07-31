function [f0Msgram, scale, step] = f0Mspectrogram(insig, fs, varargin)
%f0Mspectrum Summary of this function goes here
%   [f0Mspec, fc, mf, step] = f0Mspectrum(insig, fs, varargin)
% returns the f0M spectrum as defined in Varnet et al 2017

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
t_f0 = (1:length(f0_withnan))/(fs/undersample);

f0withoutnan = f0_withnan; f0withoutnan(isnan(f0_withnan))=[];
twithoutnan = t(1:undersample:end); twithoutnan=twithoutnan(1:length(f0_withnan)); twithoutnan(isnan(f0_withnan))=[];

if do_silent == 0
    fprintf('calculating envelope wavlets\n');
end

fb = cwtfilterbank('SignalLength',length(t_f0),'SamplingFrequency',fs/undersample,'FrequencyLimits',[mflow mfhigh],'Wavelet','morse');%'TimeBandwidth',120,

%freqz(fb)
%f0_withnan(isnan(f0_withnan)) = 0;
[wt,scale] = cwt(f0_withnan,'FilterBank',fb);
f0Msgram = abs(wt)';
    
if nargout>=3
    step.t = t_f0;
    step.f0 = f0_withnan;
    step.flags = flags;
    step.kv = kv;
    step.scale = scale;
end

end
