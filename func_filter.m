% This code is writted by Ahmadreza Attarpour
% Github ID: AAttarpour
% Email: a.attarpour@mail.utoronto.ca
%  Explanation:
    % 1) this function gets a signal, its sampling rate (fs), 
    % cut-off frequency of a lowpass and highpass filters (fl and fh), and 
    % their order (n). The output is the filtered signal.
    % 2) if fh (or fl) equals 0, it won't apply that highpass (or lowpass) filter 
% Example: filtered_s = func_filter(s, 250, 10, 0.05, 4)
function [filtered_signal] = func_filter(signal,fs,fl,fh,n)
if fh == 0
    [cl,dl]=butter(n,fl/(fs/2));
    filtered_signal=filtfilt(cl,dl,signal);
elseif fl == 0 
    [ch,dh]=butter(n,fh/(fs/2),'high');
    filtered_signal=filtfilt(ch,dh,signal);
else
    [cl,dl]=butter(n,fl/(fs/2));
    filtered_signal=filtfilt(cl,dl,signal);
    [ch,dh]=butter(n,fh/(fs/2),'high');
    filtered_signal=filtfilt(ch,dh,filtered_signal);
end
end
