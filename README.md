# PPG_Processing
These are my PPG processing scripts related to our paper entitled "Vascular origins of low-frequency oscillations in the cerebrospinal fluid signal in resting-state fMRI: Interpretation using photoplethysmography". https://doi.org/10.1002/hbm.25392

Explanation of the files:
1) func_filter.m

This function gets a signal, its sampling rate (fs), cut-off frequency of a lowpass and highpass filters (fl and fh), and their order (n). The output is the filtered signal. If fh (or fl) equals 0, it won't apply that highpass (or lowpass) filter 

2) PPG_feature_extraction.m

This function gets a PPG signal, its sampling rate (Fs), cut-off frequency of a lowpass (fl), and the sampling rate of fMRI time seris (fs_fMRI). The code uses func_maxminfinder.m to find the min and max of the signals.
Outputs: the features (PIR, SDPPG, b/a, and HRV) will be extracted, interpolated, and then resampled to fs_fMRI, so that they can be analyzed/compared together.

3) func_maxminfinder.m

This function recieves the PPG or Second Derivative of PPG signal and find its minimum and maximums in each cycle.

Example:
The following image shows a PPG signal and how maxminfinder function works. Note that we didn't apply any highpass filtering as we were interedted in low frequencies if PPG signals (specifically around 0.05-0.1 Hz).

![image](https://user-images.githubusercontent.com/70978461/120127456-6b51bb00-c18d-11eb-94ad-c528e9e362b1.png)

Subsequently, PIR, HRV, and b/a features are extracetd, interpolated, and then resampled to the sample frequency of our fMRI signals (1/0.38). The following images show these features as an example. 

![image](https://user-images.githubusercontent.com/70978461/120127837-79eca200-c18e-11eb-9127-ae3e00815b15.png)


![image](https://user-images.githubusercontent.com/70978461/120128270-a523c100-c18f-11eb-9b1f-0c31641a92db.png)


![image](https://user-images.githubusercontent.com/70978461/120131341-3eee6c80-c196-11eb-9d6b-21d8452c7189.png)



