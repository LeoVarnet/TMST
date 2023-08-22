# Temporal Modulation Spectrum Toolbox (TMST)
## Overview

The Temporal Modulation Spectrum Toolbox is a Matlab toolbox designed for the computation of amplitude- and f0-modulation spectra and spectrograms. This versatile toolbox has been developed to analyze temporal modulations in audio signals and has proven useful in various research applications, including speech signal analysis and the study of natural soundscapes.
TMST is an updated version of the "AM_FM_spectra" scripts used by Varnet et al. (2017) and available on Github (https://github.com/LeoVarnet/AM_FM_Spectra). While the core functionality remains the same, certain parameters, such as the modulation quality factor Q, have been refined to enhance the accuracy of the analysis. Please note that, because of these changes, the authors cannot guarantee exact reproducibility of results as obtained with the previous scripts.

## Features

- Computation of Amplitude-Modulation Spectra (AMspectrum.m) and f0-Modulation Spectra (f0Mspectrum.m) from a sound. This provides valuable insight into the amount of temporal modulation present in the signal, across different modulation rates. In the case of speech sounds, the different rhythms have been associated to various linguistic content (phonetic rhythm, syllabic rhythm...). This is based on an auditory filterbank decomposition of the signal.
  
- This information can also be displayed as spectrograms (functions AMscalogram.m and f0Mscalogram.m) to reveal the dynamics of the modulation rhythms across time.
  
- The function AMIspectrum.m computes the excitation pattern in the audio/modulation frequency channels, using a simple model of the human aditory system.

See section [Example WalkThrough](https://github.com/LeoVarnet/TMST/blob/main/README.md#example-walkthrough) for an illustration of the use of these functions.

## Dependencies

Before using the Temporal Modulation Spectrum Toolbox, please ensure you have the following dependencies installed:
- [Auditory Modeling Toolbox](https://amtoolbox.org/)
- [YIN](http://audition.ens.fr/adc/sw/yin.zip)

## Getting Started

- System Requirements: TMST is designed for Matlab and requires a compatible version of the software to function correctly. It is recommended to use Matlab R2017b or later for optimal performance.
- Installation: To install the toolbox, follow these steps:
a. Install the Auditory Modeling Toolbox (AMT) and YIN, as mentioned in the "Dependencies" section above.
b. Clone or download the TMST repository and add the toolbox folder to your Matlab path.
c. Run the "startup_TMST.m" script to set up the toolbox environment and load necessary functions.
- Usage: To use TMST, call the provided functions from your Matlab script or command window. The "demo_toolbox.m" script illustrates the possibilities of the toolbox on an excerpt from Simone Signoret's voice (see section [Example WalkThrough](https://github.com/LeoVarnet/TMST/blob/main/README.md#example-walkthrough)).

## References

Here are some example use cases of the Temporal Modulation Spectrum Toolbox:

### Speech Signals:
Varnet, L., Ortiz-Barajas, M. C., Erra, R. G., Gervain, J. & Lorenzi, C. A cross-linguistic study of speech modulation spectra. J. Acoust. Soc. Am. 142, 1976 (2017).

### Natural Soundscapes:
Thoret, E., Varnet, L., Boubenec, Y., Ferrière, R., Le Tourneau, F.-M., Krause, B., Lorenzi, C. Characterizing amplitude and frequency modulation cues in natural soundscapes: A pilot study on four habitats of a biosphere reserve. The Journal of the Acoustical Society of America 147, 3260–3274 (2020).

## How to cite this repository

This repository can be cited as follows: 

L. Varnet (2023). "Temporal Modulation Spectrum Toolbox: A Matlab toolbox for the computation of amplitude- and f0- modulation spectra and spectrograms." 

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

## Example Walkthrough

This is a step-by-step demonstration on the main functions of TMST, applied to the sound 'LaVoixHumaine_6s.wav', an excerpt from Jean Cocteau's La Voix Humaine recorded by Simone Signoret.

![AM spectrum](https://github.com/LeoVarnet/TMST/blob/main/demo/demo_1.JPG)
The AM spectrum ("AMa spectrum" in Varnet et al., 2017) is obtained by first computing an auditory spectrogram, then transforming the envelope in each auditory channel to the Fourier domain. The Envelope power spectrum is preserved during these operations (with a small error corresponding to the range of the FFT)

![AM auditory spectrum](https://github.com/LeoVarnet/TMST/blob/main/demo/demo_4.jpg)
Same as the AM spectrum but using more biologically-inspired modulation filterbank, composed of logarithmically-spaced, constant-Q filters. The AMi includes an additional step where each channel is divided by the DC component (Weber constant), see Varnet et al. (2017). The AMi spectrum cannot be marginalized to approximate the Envelope power spectrum.

![AM scalogram](https://github.com/LeoVarnet/TMST/blob/main/demo/demo_2.JPG)
The AM scalogram is also obtained from the auditory spectrogram of the waveform. Contrary to the AM spectrum, a windowed Fourier transform is used to display the temporal dynamics of the modulation spectrum. The size of the Gaussian window is proportional to the period considered, resulting in a scalogram. The marginalized modulation spectrum does not exactly match the overall modulation spectrum of the signal, partly due to the limited precision of the scalogram.

![AM wavelet](https://github.com/LeoVarnet/TMST/blob/main/demo/demo_3.JPG)
Same as the AM scalogram but using MATLAB's wavelet function.

![f0M spectrum](https://github.com/LeoVarnet/TMST/blob/main/demo/demo_5.JPG)
The f0M spectrum corresponds to the FFT of the signal's fundamental frequency, extracted using the YIN toolbox. Because the fundamental frequency is piecewise, a Lomb periodgram function is used.

![f0M scalogram](https://github.com/LeoVarnet/TMST/blob/main/demo/demo_6.JPG)
An extension of the concept of scalogram to the case of a piecewise signal like the fundamental frequency. Although this representation is not perfect (in particular, no windowing function is applied), it provides an insight into the dynamics of the f0 modulations.
