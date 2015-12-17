function [ inside, BPM , difference , veridict , v ] = noiseDetector( ecg , fs )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

%% Normalization
mean_ecg = mean(ecg);
e0 = ecg - mean_ecg;
e0 = e0 / max(e0);

%% Histogram
N = histcounts(diff(e0),[-0.25 0.25]);
inside = N / length(e0);

%% BPM
Rindexes = RPeakDetector( e0 , fs );
BPM = ( length(Rindexes)*60 ) / max(t);

%% Filtering
order = 4;
wc = 25; %Cut-off freq in Hz
fc = wc/(0.5*fs); %Normalized cut-off freq

[b,a] = butter(order,fc);
ecg_filtered = filtfilt(b , a , e0);

difference = sum( (e0-ecg_filtered).^2 );

%% Classify
v1 = BPM<10 || BPM > 240;
v2 = difference > 0.01;
v3 = inside < 0.99;
v = [v1 v2 v3];

if (v1+v2+v3) >= 2
    veridict = -1;
else
    veridict = 0;
end


end

