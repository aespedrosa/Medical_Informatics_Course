function [ Rindexes , BPM , difference , auc , veridict , v ] = noiseFeatExtract( ecg_norm , fs , display)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

N = length(ecg_norm);
t = 0:(1/fs):N/fs-(1/fs);

%% Histogram
% N = histcounts(diff(e0),[-0.25 0.25]);
% inside = N / length(e0);

%% BPM
[Rindexes , BPM ] = RPeakDetector( ecg_norm , fs , false);

%% Filtering
order = 4;
wc = 40; %Cut-off freq in Hz
fc = wc/(0.5*fs); %Normalized cut-off freq

[b,a] = butter(order,fc);
ecg_filtered = filtfilt(b , a , ecg_norm);

difference = sum( (ecg_norm-ecg_filtered).^2 );

%% Frequency Domain
Pxx = pburg(ecg_norm,20);
auc = trapz(Pxx);

%% Classify
v1 = BPM<10 || BPM > 180;
v2 = difference > 0.2;
%v3 = inside < 0.9;
v4 = auc > 15;
v = [v1 v2 v4];

if (v1+v2+v4) >= 2
    veridict = -1;
else
    veridict = 0;
end


end

