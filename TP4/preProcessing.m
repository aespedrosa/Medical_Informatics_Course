function [ e0 , ecg_processed ] = preProcessing( ecg , fs )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Normalization
mean_ecg = mean(ecg);
e0 = ecg - mean_ecg;
e0 = e0 / max(e0);

%% Low Pass Filter
order = 6;
wc = 30; %Cut-off freq in Hz
fc = wc/(0.5*fs); %Normalized cut-off freq

[b,a] = butter(order,fc,'low');
e1 = filtfilt(b , a , e0);

%% High Pass Filter
wc = 1;
fc = wc/(0.5*fs);

[b,a] = butter(order,fc,'high');
e2 = filtfilt( b , a , e1 );

ecg_processed = e2;

end