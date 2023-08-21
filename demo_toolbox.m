%% Simple example to demonstrate the possibilities of the TMST

clc
clear all
close all

[S, fs] = audioread("LaVoixHumaine_6s.wav");
dur = length(S)/fs;
S = S/rms(S);
t = (1:length(S))/fs;

%% AM spectrum

[AMspec, fc, mf, step] = AMspectrum(S, fs);

figure;
subplot(3,5,[1 2],'align'); plot(t, S); ylim((max(abs(S))+1)*[-1 +1]); xlim([0 dur]);title('waveform');set(gca,'XTick',[]);
subplot(3,5,[6 7 11 12],'align'); h = pcolor(step.t, fc, 20*log10(step.E'));title('auditory spectrogram');colormap(tmst_inferno());caxis([-80 10]); xlabel('Time (s)'); ylabel('Frequency (Hz)');set(gca,'XTick',[]);
set(h,'Edgecolor','none');
subplot(3,5,[3 4],'align'); semilogx(mf, 10*log10(mean(AMspec,2))); xlim(mf([1 end])); title('marginalized AM spectrum'); ylabel('PSD (dB/Hz)');set(gca,'XTick',[]); %xlabel('Modulation freq. (Hz)'); 
subplot(3,5,[8 9 13 14],'align'); h = pcolor(mf, fc, 10*log10(AMspec')); title('AM spectrum'); colormap(tmst_inferno());caxis([-80 10]); xlabel('Modulation freq. (Hz)'); set(gca,'YTick',[]); %ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');set(gca, 'XScale', 'log');
subplot(3,5,[10 15],'align'); plot(fc,10*log10(mean(1.9*step.gamma_responses.^2,1)),'r'); hold on; plot(fc,10*log10(mean(step.E.^2,1)),'b'); hold on; plot(fc,10*log10(AMspec'*diff(step.mfb)'),'g'); set(gca,'XTick',[]); 
legend({'2*Excitation pattern','True envelope power','Estimated from AM spectrum'}); view([-90 90]); ylabel('dB')
xlim(fc([1 end]))

%% AM scalogram

[AMsgram, fc_spectro, scale_spectro, step] = AMscalogram(S, fs, 5);

figure;
subplot(5,3,[1 2],'align'); plot(t, S); ylim((max(abs(S))+1)*[-1 +1]); xlim([0 dur]);title('waveform');set(gca,'XTick',[]);%xlabel('Time (s)'); 
subplot(5,3,[4 5 7 8],'align'); h = pcolor(t, step.fc, 20*log10(step.E'));title('auditory spectrogram');colormap(tmst_inferno());caxis([-80 10]); ylabel('Frequency (Hz)'); set(gca,'XTick',[]);%xlabel('Time (s)'); 
set(h,'Edgecolor','none');%colorbar 
subplot(5,3,[10 11 13 14],'align'); h = pcolor(step.t, step.scale, 20*log10(AMsgram')); title('AM scalogram'); colormap(tmst_inferno()); ylabel('Modulation freq. (Hz)'); xlabel('Time (s)')
set(h,'Edgecolor','none');
set(gca, 'YScale', 'log');
subplot(5,3,[12 15],'align');
semilogx(mf, 10*log10(mean(AMspec,2))); hold on
semilogx(step.scale, 20*log10(nanmean(AMsgram,1))); hold on
legend({'AM spectrum','from AM scalo.'}); xlim([min(step.scale) max(step.scale)]); view([-90 90]); ylabel('dB/Hz');set(gca,'XTick',[]);

%% AM wavelet

[AMsgram, fc_spectro, scale_spectro, step_spectro] = AMwavelet(S, fs);

figure;
subplot(5,3,[1 2],'align'); plot(t, S); ylim((max(abs(S))+1)*[-1 +1]); xlim([0 dur]);title('waveform'); set(gca,'XTick',[]);%xlabel('Time (s)'); 
subplot(5,3,[4 5 7 8],'align'); h = pcolor(step_spectro.t, fc, 20*log10(step_spectro.E'));title('auditory spectrogram');colormap(tmst_inferno());caxis([-80 10]); ylabel('Frequency (Hz)'); set(gca,'XTick',[]);%xlabel('Time (s)'); 
set(h,'Edgecolor','none');%colorbar
subplot(5,3,[10 11 13 14],'align'); h = pcolor(t, scale_spectro, 20*log10(AMsgram')); title('AM wavelet'); colormap(tmst_inferno()); ylabel('Modulation freq. (Hz)'); xlabel('Time (s)'); 
set(h,'Edgecolor','none');
set(gca, 'YScale', 'log');
subplot(5,3,[12 15],'align');
semilogx(mf, 10*log10(mean(AMspec,2))); hold on
semilogx(scale_spectro, 20*log10(mean(AMsgram,1))); hold on
legend({'AM spectrum','from AM wavelet'}); xlim([min(scale_spectro) max(scale_spectro)]); view([-90 90]); ylabel('dB/Hz'); set(gca,'XTick',[]);

%% AMi spectrum and auditory AM spectrum

[AMispec, fc, mf, step] = AMIspectrum(S, fs);

figure;
subplot(3,7,[1 2],'align'); plot(t, S),xlim([0 dur]);title('waveform');%xlabel('Time (s)'); 
subplot(3,7,[8 9 15 16],'align'); h = pcolor(step.t, fc, 20*log10(step.E'));title('auditory spectrogram');colormap(tmst_inferno());caxis([-80 10]); xlabel('Time (s)'); ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');%colorbar
subplot(3,7,[3 4],'align'); semilogx(mf, 10*log10(mean(step.AMrms.^2,2))); title('marginalized aud. AM spec.'); ylabel('mean envelope PSD (dB)');%xlabel('Modulation freq. (Hz)'); 
subplot(3,7,[10 11 17 18],'align'); h = pcolor(mf, fc, 10*log10(step.AMrms'.^2)); title('auditory AM spectrum'); colormap(tmst_inferno()); xlabel('Modulation freq. (Hz)'); %ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');set(gca, 'XScale', 'log');
subplot(3,7,[5 6],'align'); semilogx(mf, mean(AMispec,2)); title('marginalized AMi spec.'); ylabel('modulation index');%xlabel('Modulation freq. (Hz)'); 
subplot(3,7,[12 13 19 20],'align'); h = pcolor(mf, fc, AMispec'); title('AMi spectrum'); colormap(tmst_inferno()); xlabel('Modulation freq. (Hz)'); %ylabel('Frequency (Hz)')
set(h,'Edgecolor','none');set(gca, 'XScale', 'log');
subplot(3,7,[14 21],'align'); plot(fc,10*log10(mean(1.9*step.gamma_responses.^2,1)),'r'); hold on; plot(fc,10*log10(mean(step.E.^2,1)),'b'); hold on; plot(fc,10*log10(mean(step.AMrms.^2,1)),'g'); 
legend({'2*excitation pattern','true envelope power','from aud. AM spec.'}); view([-90 90]); ylabel('dB')
xlim(fc([1 end]))

%% f0M spectrum

[f0Mspec, mf, step] = f0Mspectrum(S, fs);

figure;
subplot(2,4,[1 2],'align'); plot(t, S); ylim((max(abs(S))+1)*[-1 +1]); xlim([0 dur]);title('waveform');
subplot(2,4,[5 6],'align'); plot(step.t, step.f0); ylim([min(step.f0)-30 max(step.f0)+30]); xlim([0 dur]);title('f0'); xlabel('Time (s)'); ylabel('Frequency (Hz)')
subplot(2,4,[7 8],'align'); semilogx(mf, 10*log10(f0Mspec)); xlim(mf([1 end])); title('f0M spectrum'); ylabel('f0 PSD (dB/Hz)');xlabel('Modulation freq. (Hz)'); 

%% f0M scalogram

[f0Msgram, scale_spectro, step_spectro] = f0Mscalogram(S, fs, 5);
%%
figure;
subplot(4,3,[1 2],'align'); plot(t, S); ylim((max(abs(S))+1)*[-1 +1]); xlim([0 dur]);title('waveform'); set(gca,'XTick',[]);
subplot(4,3,[4 5],'align'); plot(step_spectro.t_yin, step_spectro.f0); ylim([min(step_spectro.f0)-30 max(step_spectro.f0)+30]); xlim([0 dur]);title('f0'); ylabel('Frequency (Hz)');set(gca,'XTick',[]);%xlabel('Time (s)'); 
subplot(4,3,[7 8 10 11],'align'); h = pcolor(step_spectro.t, step_spectro.scale, 20*log10(f0Msgram')); title('f0M scalogram'); colormap(tmst_inferno()); ylabel('Modulation freq. (Hz)'); xlabel('Time (s)')
set(h,'Edgecolor','none');
set(gca, 'YScale', 'log');
subplot(4,3,[9 12],'align');
semilogx(mf, 10*log10(f0Mspec)); hold on
semilogx(step_spectro.scale, 20*log10(nanmean(f0Msgram,1))); hold on
legend({'f0M spectrum','from f0M scalo.'}); xlim([min(step_spectro.scale) max(step_spectro.scale)]); view([-90 90]); ylabel('dB/Hz'); set(gca,'XTick',[]);
