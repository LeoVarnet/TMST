function [outsig, mfc, step] = king2019_modfilterbank_updated(insig,fs,varargin)
%king2019_modfilterbank_updated
%
%   Usage: [outsig, mfc, step] = king2019_modfilterbank_updated(insig,fs,varargin)
% 
%   Input parameters:
%     insig: Input signal(s)
%     fs     : Sampling rate in Hz
%     fc     : Centre frequencies of the input signals
%     mflow  : minimum modulation centre frequency in Hz
%     mfhigh : maximum modulation centre frequency in Hz
%     N      : Number of logarithmically-spaced (between fmin and fmax) 
%              modulation filters (default N = 10)
%     Qfactor: Quality factor of the filters (default Qfactor = 1).
%
%   Output parameters:
%     outsig: Modulation filtered signals 
%     mfc   : Centre frequencies of the modulation filters
%     step  : Contains some intermediate outputs.
%
%   #Author: Leo Varnet and Andrew King (2020)
%   #Author: Alejandro Osses (2020) Original implementation for the AMT
%   #Author: Clara Hollomey (2021) Adapted for AMT
%   #Author: Piotr Majdak (2021) Further adaptations to AMT 1.0
%
%   Url: http://amtoolbox.sourceforge.net/amt-0.10.0/doc/modelstages/king2019_modfilterbank.php

% Copyright (C) 2009-2020 Piotr Majdak and the AMT team.
% This file is part of Auditory Modeling Toolbox (AMT) version 1.0.0
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

definput.keyvals.mfc=[];
[flags,kv]=ltfatarghelper({},definput,varargin);

% first order modulation Butterworth lowpass filter with a cut-off
% frequency of 150 Hz. This is to remove all modulation frequencies
% above 150 Hz. The motivation behind this filter can be found in kohlrausch2000
if flags.do_LP_150_Hz % modbank_LPfilter
    [b_highest,a_highest] = butter(1,150/(fs/2));
    insig = filter(b_highest,a_highest,insig);
end

% Parameters modulation filter:
mflow           = kv.mflow; 
mfhigh          = kv.mfhigh; 
modbank_Nmod    = kv.modbank_Nmod;
modbank_Qfactor = kv.modbank_Qfactor;
    
% -------------------------------------------------------------------------
% -- 1. modulation_filterbank.m
if isempty(modbank_Nmod)
    step_mfc = (sqrt(4*modbank_Qfactor^2+1)+1)/(sqrt(4*modbank_Qfactor^2+1)-1);
    logfmc = log(mflow):log(step_mfc):log(mfhigh);
    
    modbank_Nmod = length(logfmc);
else
    logfmc = linspace(log(mflow), log(mfhigh), modbank_Nmod); %log(fmin):log((sqrt(4*Qfactor^2+1)+1)/(sqrt(4*Qfactor^2+1)-1)):log(fmax);
end
mfc = exp(logfmc);

for ichan = 1:modbank_Nmod
    flim(ichan,:) = mfc(ichan)*sqrt(4+1/modbank_Qfactor^2)/2 +  [-1 +1]*mfc(ichan)/modbank_Qfactor/2; %sqrt((fmc(ichan)/Qfactor)^2+8*fmc(ichan))/2 + [-1 +1]*(fmc(ichan)/(2*Qfactor));% [fmc(ichan)*((sqrt(5)-(1/Qfactor))/2) fc(ichan)*((sqrt(5)+(1/Qfactor))/2)];
    [b(ichan,:),a(ichan,:)] = butter(1,2*[flim(ichan,:)]/fs); % the only difference with king2019_modfilterbank is that here we use 1st-order butterworth filters
end

% -------------------------------------------------------------------------
% 2. apply_filterbank.m

% E_mod = apply_filterbank(BB, AA, inoutsig, cfg.modbank_filtfilt);

Nchannels=size(b,1);
if size(a,1)~= Nchannels
    error('Number of lines in ''a'' and ''b'' must be equal');
end

Nsamples=size(insig,1);
Nsignals=size(insig,2);

outsig=zeros(Nsamples,Nsignals,Nchannels);

for ii=1:Nchannels
    outsig(:,:,ii) = filter(b(ii,:),a(ii,:),insig);
end

if nargout >= 3 % Intermediate outputs
    step.a = a;
    step.b = b;
    step.fs_design = fs;
    
    step.E_mod = outsig;
    step.fmc = mfc;
end
    
% -------------------------------------------------------------------------
% 3. Phase insensitivity
% ---
if flags.do_phase_insens_hilbert
  amt_disp('  Phase insensitivity (hilbert)',flags.disp);
    
    phase_insens_cut = kv.phase_insens_cut; % Hz
    
    N_fc = size(outsig,2);
    for i=1:modbank_Nmod
        if mfc(i)>phase_insens_cut
            for j=1:N_fc
                % hilbert
                outsig_env = local_hilbert_extraction(squeeze(outsig(:,j,i)));
                scal_factor = rms(outsig(:,j,i))/ rms(outsig_env); 
                outsig(:,j,i) = outsig_env * scal_factor;
            end
       end
    end
    
    if nargout>=3
        step.E_phase_ins = outsig;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outsig_env = local_hilbert_extraction(D)
% Author: Leo Varnet 2016 - last modified 11/10/2018

if isreal(D)
    hilbert_responses = hilbert(D);
else
    hilbert_responses = D;
end

outsig_env = abs(hilbert_responses);
