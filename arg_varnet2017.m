function definput = arg_varnet2017(definput)
% function definput = arg_varnet2017(definput)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Defaults for all varnet2017* functions:
% auditory frequency range
definput.keyvals.flow=70; % gammatone range (Hz), lowest frequency
definput.keyvals.fhigh=6700; % gammatone range (Hz), highest frequency
% modulation frequency range
definput.keyvals.mflow  = 0.5; % Hz, modbank_fmin
definput.keyvals.mfhigh = 200; % Hz, modbank_fmax
definput.keyvals.modbank_Nmod    = 200; % number of filters, for overalpped 
                               % filters choose 'modbank_Nmod'
                               
%%% Defaults for varnet2017_AMi.m:
%definput.keyvals.NthOct = 3;%9; % width of modulation filters for the AMi spectrum 
     % (1/X octave filters) - determines the resolution of the AMi spectrum

definput.keyvals.modbank_Qfactor = 1;% 13; % Q factor for the filters. This is for king2019_modfilterbank. In Varnet et al. 2017 we used a Q factor of 13 for representation purposes
%definput.keyvals.Q_mfb = 1;% this is for modfilterbank

definput.flags.modfilter_150Hz_LP = {'no_LP_150_Hz','LP_150_Hz'}; % modbank_LPfilter
definput.flags.modfilter_phase = {'no_phase_insens', 'phase_insens_hilbert'};

