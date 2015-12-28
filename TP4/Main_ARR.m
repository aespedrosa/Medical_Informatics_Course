%% ---------- ECG Analysis ----------- %%
% -------- Informatica Medica -------- %
% - Alexandre Campos | Andre Pedrosa - %
% --------------- 2015 --------------- %

%% =============== DATA DATPVC =============== %%
% ==================== PVC =================== %

% ----- Load ECG ----- %
clear, clc, close all;

fs = 125;

temp = what(fullfile(pwd,'DATARR'));
files = fullfile('DATARR',temp.mat);

load(files{1});

ecg = DAT.ecg;
ecg_class = DAT.class;

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

%% Preprocessing
[ecg_norm , ecg_pre] = preProcessing( ecg , fs );

%% ===== Feature Extraction and Peak Detection ===== %%
windowsize = 5; %in seconds
window = 1:(windowsize * fs);
maxindex = floor( N / (fs*windowsize) );

if maxindex<1; disp('Adjust windowsize: too large.'); end

RPeakIndexes = zeros(N,1);
BPM = zeros(maxindex,1); %BPM per window
DIFF = zeros(maxindex,1); 
AUC = zeros(maxindex,1); %AUC per window
ecg_noise_class = ecg_class;
ecg_noise_class(ecg_noise_class==4) = 0; 
trueClass = zeros(maxindex,1);
veridict = zeros(maxindex,1);

for w = 1:maxindex
    sub_ecg = ecg_norm (window);
    n = histcounts(ecg_class(window),2);
    if n(1)*4 >= n(2)
        trueClass(w) = -1;
    else
        trueClass(w) = 0;
    end
    
    trueClass(w) = mode(ecg_class(window));
    
    %---R Peaks and BPM
    [ RwindowIndexes , BPM(w) , DIFF(w) , AUC(w)] = ...
        noiseFeatExtract( sub_ecg , fs , true);
     
    RPeakIndexes(RwindowIndexes + window(1) - 1) = 1;
    
    window = window + fs*windowsize;
end

%% ===== Noise Classification ===== %%
predictedClass = noiseDetector( trueClass , BPM , DIFF , AUC );

%%
figure
subplot(2,1,1); plot(BPM,'o--'); xlim([0 length(BPM)])
hold on
line([0 length(BPM)],[mean(BPM) mean(BPM)],'Color','r')
hold on
line([0 length(BPM)],[mean(BPM)-std(BPM) mean(BPM)-std(BPM)],'Color','g')
hold on
line([0 length(BPM)],[mean(BPM)+std(BPM) mean(BPM)+std(BPM)],'Color','g')
subplot(2,1,2); plot(trueClass,'o--'); xlim([0 length(AUC)])

%%
figure
subplot(2,1,1); plot(AUC,'o--'); xlim([0 length(AUC)])
hold on
line([0 length(AUC)],[nanmean(AUC) nanmean(AUC)],'Color','r')
hold on
line([0 length(AUC)],[nanmean(AUC)-nanstd(AUC) nanmean(AUC)-nanstd(AUC)],'Color','g')
hold on
line([0 length(AUC)],[nanmean(AUC)+nanstd(AUC) nanmean(AUC)+nanstd(AUC)],'Color','g')
subplot(2,1,2); plot(ecg_class,'o--'); xlim([0 length(ecg_class)])

%%
figure
subplot(2,1,1); plot(DIFF,'o--'); xlim([0 length(DIFF)])
hold on
line([0 length(DIFF)],[mean(DIFF) mean(DIFF)],'Color','r')
hold on
line([0 length(DIFF)],[mean(DIFF)-std(DIFF) mean(DIFF)-std(DIFF)],'Color','g')
hold on
line([0 length(DIFF)],[mean(DIFF)+std(DIFF) mean(DIFF)+std(DIFF)],'Color','g')
subplot(2,1,2); plot(ecg_class,'o--'); xlim([0 length(ecg_class)])

%%
subplot(2,1,1); plot(predictedClass,'o--'); xlim([0 length(predictedClass)])
subplot(2,1,2); plot(trueClass,'o--'); xlim([0 length(trueClass)])

