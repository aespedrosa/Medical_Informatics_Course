function [ ecg_norm , ecg_processed ] = preProcessing( ecg , fs )
%preProcessing Preprocesses the ECG signal
% Inputs:
%   --> ecg - ECG signal
%   --> fs - Sampling Frequency (Hz)
%
% Outputs:
%   --> ecg_norm - Normalized ECG
%   --> ecg_processed - Preprocessed ECG

%% Normalization
mean_ecg = mean(ecg);
ecg_norm = ecg - mean_ecg;
ecg_norm = ecg_norm / max(ecg_norm);

%% Low Pass Filter
order = 6;
wc = 30; %Cut-off freq in Hz
fc = wc/(0.5*fs); %Normalized cut-off freq

[b,a] = butter(order,fc,'low');
e1 = filtfilt(b , a , ecg_norm);

%% High Pass Filter
wc = 1;
fc = wc/(0.5*fs);

[b,a] = butter(order,fc,'high');
e2 = filtfilt( b , a , e1 );

ecg_processed = e2;

end