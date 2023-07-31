# Temporal Modulation Spectrum Toolbox (TMST)
## Overview

The Temporal Modulation Spectrum Toolbox is a Matlab toolbox designed for the computation of amplitude- and f0-modulation spectra and spectrograms. This versatile toolbox has been developed to analyze temporal modulations in audio signals and has proven useful in various research applications, including speech signal analysis and the study of natural soundscapes.
TMST is an updated version of the "AM_FM_spectra" scripts used by Varnet et al. (2017) and available on Github (https://github.com/LeoVarnet/AM_FM_Spectra). While the core functionality remains the same, certain parameters, such as the modulation quality factor Q, have been refined to enhance the accuracy of the analysis. Please note that, because of these changes, the authors cannot guarantee exact reproducibility of results as obtained with the previous scripts.

## Features

- Computation of Amplitude-Modulation Spectra (AMspectrum) and Spectrograms (AMspectrogram): TMST allows users to calculate the amplitude-modulation spectrum of an audio signal, providing valuable insights into the temporal changes in signal strength across different modulation rates. This is based on an auditory filterbank decomposition of the signal. The function AMIspectrum computes the excitation pattern in the audio/modulation frequency channels.

- Computation of F0-Modulation Spectra (f0Mspectrum): The toolbox also allows the computation of f0-modulation spectra, which reveals variations in the fundamental frequency across different modulation rates.

## Dependencies

Before using the Temporal Modulation Spectrum Toolbox, please ensure you have the following dependencies installed:
- [Auditory Modeling Toolbox](https://amtoolbox.org/): TMST relies on the AMT for auditory modeling computations. Please download and install the AMT toolbox before using TMST.
- [YIN](http://audition.ens.fr/adc/sw/yin.zip): TMFT utilizes YIN for f0 extraction.

## Getting Started

- System Requirements: TMST is designed for Matlab and requires a compatible version of the software to function correctly. It is recommended to use Matlab R2017b or later for optimal performance.
- Installation: To install the toolbox, follow these steps:
a. Install the Auditory Modeling Toolbox (AMT) and YIN, as mentioned in the "Dependencies" section above.
b. Clone or download the TMFT repository and add the toolbox folder to your Matlab path.
c. Run the "startup_TMST.m" script to set up the toolbox environment and load necessary functions.
- Usage: To use TMFT, call the provided functions from your Matlab script or command window. The "demo_toolbox.m" script illustrates the possibilities of the toolbox on an excerpt from Simone Signoret's voice. 

## References

Here are some example use cases of the Temporal Modulation Spectrum Toolbox:

### Speech Signals:
Varnet, L., Ortiz-Barajas, M. C., Erra, R. G., Gervain, J. & Lorenzi, C. A cross-linguistic study of speech modulation spectra. J. Acoust. Soc. Am. 142, 1976 (2017).

### Natural Soundscapes:
Thoret, E., Varnet, L., Boubenec, Y., Ferrière, R., Le Tourneau, F.-M., Krause, B., Lorenzi, C. Characterizing amplitude and frequency modulation cues in natural soundscapes: A pilot study on four habitats of a biosphere reserve. The Journal of the Acoustical Society of America 147, 3260–3274 (2020).

## How to cite this repository

This repository can be cited as follows: 

L. Varnet (2023). "Temporal Modulation Spectrum Toolbox: the MATLAB toolbox for investigating amplitude and f0 modulations" 

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.
