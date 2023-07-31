%% Simple example to demonstrate the possibilities of the Mtoolbox

clc
clear all
close all

[S, fs] = audioread("LaVoixHumaine_8s.wav");
dur = length(S)/fs; % seconds
S = S/rms(S);
t = (1:length(S))/fs;

% AM spectrum
[AMspec, fc, mf, step] = AMspectrum(S, fs);

figure;
subplot(3,5,[1 2],'align'); plot(t, S); ylim((max(abs(S))+1)*[-1 +1]); xlim([0 dur]);title('waveform');%xlabel('Time (s)'); 
subplot(3,5,[6 7 11 12],'align'); h = pcolor(step.t, fc, 20*log10(step.E'));title('auditory spectrogram');colormap(ltfat_inferno());caxis([-80 10]); xlabel('Time (s)'); ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');%colorbar
subplot(3,5,[3 4],'align'); semilogx(mf, 10*log10(mean(AMspec,2))); xlim(mf([1 end])); title('marginalized AM spectrum'); ylabel('mean envelope PSD (dB)');%xlabel('Modulation freq. (Hz)'); 
subplot(3,5,[8 9 13 14],'align'); h = pcolor(mf, fc, 10*log10(AMspec')); title('AM spectrum'); colormap(ltfat_inferno());caxis([-80 10]); xlabel('Modulation freq. (Hz)'); %ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');set(gca, 'XScale', 'log');
subplot(3,5,[10 15],'align'); plot(fc,10*log10(mean(1.9*step.gamma_responses.^2,1)),'r'); hold on; plot(fc,10*log10(mean(step.E.^2,1)),'b'); hold on; plot(fc,10*log10(AMspec'*diff(step.mfb)'),'g'); 
legend({'2*Excitation pattern','True envelope power','Estimated from AM spectrum'}); view([-90 90]); ylabel('dB')
xlim(fc([1 end]))

%% AM spectrogram

% TODO: permute the dimensions of AMspectro
[AMsgram, fc_spectro, scale_spectro, step_spectro] = AMspectrogram(S, fs);

figure;
subplot(5,3,[1 2],'align'); plot(t, S); ylim((max(abs(S))+1)*[-1 +1]); xlim([0 dur]);title('waveform');%xlabel('Time (s)'); 
subplot(5,3,[4 5 7 8],'align'); h = pcolor(step.t, fc, 20*log10(step.E'));title('auditory spectrogram');colormap(ltfat_inferno());caxis([-80 10]); ylabel('Frequency (Hz)');%xlabel('Time (s)'); 
set(h,'Edgecolor','none');%colorbar
subplot(5,3,[10 11 13 14],'align'); h = pcolor(t, scale_spectro, 20*log10(AMsgram)); title('AM spectrogram'); colormap(ltfat_inferno()); ylabel('Modulation freq. (Hz)'); xlabel('Time (s)')
set(h,'Edgecolor','none');
set(gca, 'YScale', 'log');
subplot(5,3,[12 15],'align');
semilogx(mf, 10*log10(mean(AMspec,2))); hold on
semilogx(scale_spectro, 20*log10(mean(AMsgram,2))); hold on
legend({'AM spectrum','Estimated from AM spectro.'}); xlim([min(scale_spectro) max(scale_spectro)]); view([-90 90]); ylabel('dB')

%%
% TODO: permute the dimensions of AMi
% AMi spectrum
[AMispec, fc, mf, step] = AMIspectrum(S, fs);

figure;
subplot(3,7,[1 2],'align'); plot(t, S),xlim([0 dur]);title('waveform');%xlabel('Time (s)'); 
subplot(3,7,[8 9 15 16],'align'); h = pcolor(step.t, fc, 20*log10(step.E'));title('auditory spectrogram');colormap(ltfat_inferno());caxis([-80 10]); xlabel('Time (s)'); ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');%colorbar
subplot(3,7,[3 4],'align'); semilogx(mf, 10*log10(mean(step.AMrms'.^2,2))); title('marginalized aud. AM spec.'); ylabel('mean envelope PSD (dB)');%xlabel('Modulation freq. (Hz)'); 
subplot(3,7,[10 11 17 18],'align'); h = pcolor(mf, fc, 10*log10(step.AMrms.^2)); title('auditory AM spectrum'); colormap(ltfat_inferno()); xlabel('Modulation freq. (Hz)'); %ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');set(gca, 'XScale', 'log');
subplot(3,7,[5 6],'align'); semilogx(mf, mean(AMispec)); title('marginalized AMi spec.'); ylabel('modulation index');%xlabel('Modulation freq. (Hz)'); 
subplot(3,7,[12 13 19 20],'align'); h = pcolor(mf, fc, AMispec); title('AMi spectrum'); colormap(ltfat_inferno()); xlabel('Modulation freq. (Hz)'); %ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');set(gca, 'XScale', 'log');

subplot(3,7,[14 21],'align'); plot(fc,10*log10(mean(1.9*step.gamma_responses.^2,1)),'r'); hold on; plot(fc,10*log10(mean(step.E.^2,1)),'b'); hold on; plot(fc,10*log10(mean(step.AMrms'.^2,1)),'g'); 
legend({'2*Excitation pattern','True envelope power','Estimated from aud. AM spec.'}); view([-90 90]); ylabel('dB')
xlim(fc([1 end]))