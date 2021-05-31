% This code is writted by Ahmadreza Attarpour
% Github ID: AAttarpour
% Email: a.attarpour@mail.utoronto.ca
% Explanation:
% This function recieves the PPG or Second Derivative of PPG signal and find its minimum and maximums in each cycle.
% Example: [maxpks, maxind, minpks, minind] = func_maxminfinder(signal,idx5000)
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
