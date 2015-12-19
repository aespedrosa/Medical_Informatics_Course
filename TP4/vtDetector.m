function [ BPM , veridict , auc] = vtDetector( ecg , fs )
%VTDETECTOR Summary of this function goes here
%   Detailed explanation goes here

% Data Source: DATARR

% Por janelas
% Numero de batimentos
% Freq interna
% Deteccao picos

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

%% Normalization
mean_ecg = mean(ecg);
e0 = ecg - mean_ecg;
e0 = e0 / max(e0);

%% BPM
ecg_processed = preProcessing(e0 , fs);
Rindexes = RPeakDetector( ecg_processed , fs , false);
BPM = ( length(Rindexes)*60 ) / max(t);

%% Frequency Domain
Pxx = pburg(e0,20);
auc = trapz(Pxx);

%% Classify
v1 = BPM<10 || BPM > 105;

if (v1) >= 2
    veridict = -1;
else
    veridict = 0;
end

end