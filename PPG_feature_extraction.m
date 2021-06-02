% This code is writted by Ahmadreza Attarpour
% Github ID: AAttarpour
% Email: a.attarpour@mail.utoronto.ca
% Explanation:
% this function gets a PPG signal, its sampling rate (Fs), 
% cut-off frequency of a lowpass (fl), and the sampling rate of fMRI time seris (fs_fMRI). 
% It also recieves the indexes of 5000 values that the Siemens scanners add to PPG signals.
% The code uses func_maxminfinder.m to find the min and max of the signals.
% Outputs: the features (PIR, SDPPG, b/a, and HRV) will be extracted, interpolated,
% and then resampled to fs_fMRI, so that they can be analyzed together. 
% Example: [resampled_PIR, resampled_SDPPG, resampled_HRV, resampled_ba] = PPG_feature_extraction(ppg, idx5000, 50, 4, 1/0.38)
function [resampled_PIR, resampled_SDPPG, resampled_HRV, resampled_ba] = PPG_feature_extraction(ppg, idx5000, Fs, fl, fs_fMRI)
Ts = 1/Fs;

%% filtering signal using func_filter function
%%
filtered_ppg=func_filter(ppg,Fs,fl,0,3);
    
%% calculate max and min peaks using func_maxminfinder
%%
[maxpks, maxind, minpks, minind] = func_maxminfinder(filtered_ppg,idx5000);

%% interpolate max and min to the length of signal
%%
t = length(filtered_ppg)/Fs;
time = 0:Ts:t-Ts;
maxind_time = maxind./Fs;
minind_time = minind./Fs;
maxpks_interpolate = spline(maxind_time,maxpks,time);
minpks_interpolate = spline(minind_time,minpks,time);

%% calculate PIR
%% 
PIR = maxpks_interpolate./minpks_interpolate;
PIR_abs = abs(PIR);
PIR(find(PIR_abs>(2*mean(PIR_abs)))) = mean(PIR);
figure;plot(PIR);title('PIR');

%% calculate HRV
%% 
maxpks_interpolate1 = maxpks_interpolate;
maxpks_interpolate1(1) = [];
maxpks_interpolate1(length(maxpks_interpolate))=100;
HRV = maxpks_interpolate1 - maxpks_interpolate;
HRV(end)=[];
HRV_abs = abs(HRV);
HRV(find(HRV_abs>(mean(HRV_abs) + 3*std(HRV_abs)))) = mean(HRV);

figure;plot(HRV);title('HRV');

%% calculate SDPPG
%% 
filtered_ppg = filtered_ppg - mean(filtered_ppg);
SDPPG=diff(diff(filtered_ppg)*Fs)*Fs;

%figure;plot(SDPPG);title('SDPPG');

%% calculate b/a
%% 
[maxpks_SD, maxind_SD, minpks_SD, minind_SD] = func_maxminfinder(SDPPG,minind);
minpks_SD(1) = [];minind_SD(1) = []; % the first one is detected wrongly due to the func_maxminfinder function
maxind_SD(end) = []; maxpks_SD(end) =[]; % this peak doesn't have its relative min or b point

%% interpolate max and min to the length of signal
%% 
t = length(SDPPG)/Fs;
time = 0:Ts:t-Ts;
maxind_SD_time = maxind_SD./Fs;
minind_SD_time = minind_SD./Fs;
maxpks_SD_interpolate = spline(maxind_SD_time,maxpks_SD,time);
maxpks_SD_interpolate(find(maxpks_SD_interpolate<mean(maxpks_SD_interpolate)/4)) = mean(maxpks_SD_interpolate);
minpks_SD_interpolate = spline(minind_SD_time,minpks_SD,time);
minpks_SD_interpolate(find(minpks_SD_interpolate<mean(minpks_SD_interpolate)/4)) = mean(minpks_SD_interpolate);
ba = minpks_SD_interpolate ./ maxpks_SD_interpolate;
ba_abs = abs(ba);
ba(find(ba_abs>(mean(ba_abs) + 3*std(ba_abs)))) = mean(ba);
figure;plot(ba);title('b/a');

%% resample PIR, SDPPG, HRV, and b/a to fMRI sampling rate
%% 
% resampling data
% low-pass filter with 1.3 Hz cutt-off frequency to avoid aliasing
filtered_PIR=func_filter(PIR,Fs,1.3,0,4);
resampled_PIR = filtered_PIR(1:Fs/fs_fMRI:end);

filtered_SDPPG=func_filter(SDPPG,Fs,1.3,0,4);
resampled_SDPPG = filtered_SDPPG(1:Fs/fs_fMRI:end);

filtered_HRV=func_filter(HRV,Fs,1.3,0,4);
resampled_HRV = filtered_HRV(1:Fs/fs_fMRI:end);

filtered_ba=func_filter(ba,Fs,1.3,0,4);
resampled_ba = filtered_ba(1:Fs/fs_fMRI:end);


end
