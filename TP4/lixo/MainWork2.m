clear, clc;

fs = 1000;

ecg = load('data/ecgPVC.dat');

N = length(ecg);

t = 0:(1/fs):N/fs-(1/fs);

p_ecg = preprocessECG(ecg,fs);

figure()
    subplot(2,1,1); plot(t,ecg); title('Raw ECG'); xlim([min(t) max(t)]);
    subplot(2,1,2); plot(t,p_ecg); title('Preprocessed ECG'); xlim([min(t) max(t)]);
    
    
Rindexes = findRpeaks(p_ecg , fs , t);

%%
ecg_diff = diff(ecg);
ecg_diff2 = diff(e2);

windowSize = 20*fs;

av = mean(ecg_diff(1:windowSize));
s = std(ecg_diff(1:windowSize));

threshold = max(hist(ecg_diff(1:windowSize)) / 10);

figure()
histogram(ecg_diff(1:windowSize));
figure()
histogram(ecg_diff2(1:windowSize));







