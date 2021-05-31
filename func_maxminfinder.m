% This code is writted by Ahmadreza Attarpour
% Github ID: AAttarpour
% Email: a.attarpour@mail.utoronto.ca
% Explanation:
    % 1) this function gets a signal, its sampling rate (fs), 
    % cut-off frequency of a lowpass and highpass filters (fl and fh), and 
    % their order (n). The output is the filtered signal.
    % 2) if fh (or fl) equals 0, it won't apply that highpass (or lowpass) filter 
% Example: filtered_s = func_filter(s, 250, 10, 0.05, 4)
function [maxpks, maxind, minpks, minind] = func_maxminfinder(a,idx5000)
L = length(idx5000);
idx1 = idx5000;
idx5000(1) = [];
idx5000(L) = 100;
temp = idx5000 - idx1;
temp(end) = [];

th1 = mean(temp) * 65/100;
[maxpks,maxind]=findpeaks(a,'MinPeakDistance',th1,'MinPeakHeight', mean(a));
figure;plot(a,'linewidth',1.5);hold on;plot(maxind,maxpks,'o','linewidth',1.5);

% a=-a;
% th2 = mean(temp) * 65/100;
% [minpks,minind]=findpeaks(a,'MinPeakDistance',th2,'MinPeakHeight', mean(a));
% minpks=-minpks;
% hold on;plot(minind,minpks,'o','linewidth',1.5);

l = length(maxpks);
for idx = 1:l-1
    w_min = a(maxind(idx):maxind(idx+1))';
    [minind1,~] = find(w_min == min(w_min));
    minind(idx) = minind1 + maxind(idx);
    minpks(idx) = w_min(minind1);
end
temp = a(1:maxind(1));
[~,min_idx1] = find(temp == min(temp));
minpks = [a(min_idx1),minpks];
minind = [min_idx1,minind];
hold on;plot(minind,minpks,'o','linewidth',1.5);
end
