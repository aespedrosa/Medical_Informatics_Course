clc;
clear all;
close all;

%% Load ECG Signal
list={...
    'DARR_003', 'DARR_024', 'DARR_029', 'DARR_019', ...
    'DARR_026', 'DARR_030', 'DARR_008', 'DARR_022', ...
    'DARR_027', 'DARR_035' };

nr_file=3;
ecg_all=load(list{nr_file});
fs=125;
ecg=ecg_all.DAT.ecg;
N=length(ecg);
t=0:(1/fs):(N-1)/fs;

%% Normalizar
e0=my_normalizar(ecg);

%% Noise Detection
windowsize = 5; %in seconds
window = 1:fs*windowsize;
maxindex = floor(length(ecg) / (fs*windowsize));
pred_class=zeros(N,1);
out_noise_detection=[];
for i = 1:maxindex
    out_noise_detection=[out_noise_detection;my_noisedetection(e0(window),fs)];
    pred_class(window)=out_noise_detection(i,7);
    window=window+fs*windowsize;
end

true_class=ecg_all.DAT.class==-1;
plot(t,e0);
hold on;
plot(t,pred_class,'o');
hold on;
plot(t,true_class,'x');
legend('ECG signal','Noise Prediction', 'True Noise')

[TP,TN,FP,FN,SP,SE]=my_results(true_class,pred_class);
formatSpec = '------ Resultados DATASET %s ------  \n True Positives: %d \n False Positives: %d \n True Negatives: %d\n False Negatives: %d \n Sensibilidade: %f \n Especificidade: %f ';
str = sprintf(formatSpec,list{nr_file},TP,FP,TN,FN,SP,SE);
disp(str);

%% VT Detection - area/2 pburg
windowsize = 5; %in seconds
window = 1:fs*windowsize;
maxindex = floor(length(ecg) / (fs*windowsize));
b=[];       
for i = 1:maxindex
    b=[b;my_vtdetection(window,fs)];
    window=window+fs*windowsize;
end

true_class=ecg_all.DAT.class==4;
plot(t,e0);
hold on;
plot(t,true_class,'x');
legend('ECG signal','Noise Prediction', 'True Noise')

%% VT Detection
% windowsize = 5; %in seconds
% window = 1:fs*windowsize;
% maxindex = floor(length(ecg) / (fs*windowsize));
% polos=[];
% for i = 1:maxindex
%     polos=[polos my_vtdetection(window,fs)];
%     window=window+fs*windowsize;
% end
% 
% kmeans(polos',2);
% 

