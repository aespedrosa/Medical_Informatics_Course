function [ ecg , ecg_class , N , t ] = loadARRFile( index , fs , files)
%loadARRFile Load files in DATARR folder
% Inputs: 
%   --> index - file number
%   --> fs - Sampling frequency (Hz)
%   --> files - cell with file names
%
% Outputs:
%   --> ecg - ECG signal
%   --> ecg_class - ECG classification
%   --> N - number of data points
%   --> t - time vector

load(files{index});

ecg = DAT.ecg;
ecg_class = DAT.class;

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

end