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

load(files{5});

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
HIST = zeros(maxindex,1); 
BPM = zeros(maxindex,1); %BPM per window
DIFF = zeros(maxindex,1); 
AUC = zeros(maxindex,1); %AUC per window
AUCband = zeros(maxindex,4); %AUC per window
RATIOfreq = zeros(maxindex,1);
OTHER = zeros(maxindex,1);

trueClass = zeros(maxindex,1);
predictedClass = zeros(maxindex,1);
Nclass = zeros(maxindex,3);

for w = 1:maxindex
    sub_ecg = ecg_norm (window);
    
    Nclass(w,:) = sum([ecg_class(window)==0 ecg_class(window)==-1 ecg_class(window)==4]);
    
    if Nclass(w,2) * 2 > Nclass(w,1)
        trueClass(w) = -1;
    elseif Nclass(w,3) * 2 > Nclass(w,1)
        trueClass(w) = 4;
    end
    
    [ RwindowIndexes , HIST(w) , BPM(w) , DIFF(w) , ...
        AUC(w) , AUCband(w,:) , RATIOfreq(w) , OTHER(w)] = ...
            noiseFeatExtract( sub_ecg , fs );
     
    RPeakIndexes(RwindowIndexes + window(1) - 1) = 1;
     
    predictedClass(w) = noiseDetector(HIST(w) , BPM(w) , ...
                DIFF(w) , AUC(w) ,AUCband(w,:) , RATIOfreq(w) , OTHER(w));
    
    window = window + fs*windowsize;
end

%%
predictedClass2 = noiseDetectorFull( trueClass , HIST , BPM , DIFF , ...
    AUC , AUCband , RATIOfreq , OTHER);

%%
figure
subplot(2,1,1); plot(HIST,'o--'); xlim([0 length(HIST)])
hold on
line([0 length(HIST)],[mean(HIST) mean(HIST)],'Color','r')
hold on
line([0 length(HIST)],[mean(HIST)-std(HIST) mean(HIST)-std(HIST)],'Color','g')
hold on
line([0 length(HIST)],[mean(HIST)+std(HIST) mean(HIST)+std(HIST)],'Color','g')
subplot(2,1,2); plot(trueClass,'o--'); xlim([0 length(HIST)])


%%
figure
subplot(2,1,1); plot(BPM,'o--'); xlim([0 length(BPM)])
hold on
line([0 length(BPM)],[mean(BPM) mean(BPM)],'Color','r')
hold on
line([0 length(BPM)],[mean(BPM)-std(BPM) mean(BPM)-std(BPM)],'Color','g')
hold on
line([0 length(BPM)],[mean(BPM)+std(BPM) mean(BPM)+std(BPM)],'Color','g')
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
subplot(2,1,1); plot(RATIOfreq,'o--'); xlim([0 length(RATIOfreq)])
hold on
line([0 length(RATIOfreq)],[mean(RATIOfreq) mean(RATIOfreq)],'Color','r')
hold on
line([0 length(RATIOfreq)],[mean(RATIOfreq)-std(RATIOfreq) mean(RATIOfreq)-std(RATIOfreq)],'Color','g')
hold on
line([0 length(RATIOfreq)],[mean(RATIOfreq)+std(RATIOfreq) mean(RATIOfreq)+std(RATIOfreq)],'Color','g')
subplot(2,1,2); plot(ecg_class,'o--'); xlim([0 length(ecg_class)])

%%
figure
subplot(2,1,1); plot(AUCband(:,2),'o--'); xlim([0 length(AUCband(:,2))])
hold on
line([0 length(AUCband(:,2))],[mean(AUCband(:,2)) mean(AUCband(:,2))],'Color','r')
hold on
line([0 length(AUCband(:,2))],[mean(AUCband(:,2))-std(AUCband(:,2)) mean(AUCband(:,2))-std(AUCband(:,2))],'Color','g')
hold on
line([0 length(AUCband(:,2))],[mean(AUCband(:,2))+std(AUCband(:,2)) mean(AUCband(:,2))+std(AUCband(:,2))],'Color','g')
subplot(2,1,2); plot(ecg_class,'o--'); xlim([0 length(ecg_class)])


%%
figure
subplot(2,1,1); plot(AUCband(:,3),'o--'); xlim([0 length(AUCband(:,3))])
hold on
line([0 length(AUCband(:,3))],[mean(AUCband(:,3)) mean(AUCband(:,3))],'Color','r')
hold on
line([0 length(AUCband(:,3))],[mean(AUCband(:,3))-std(AUCband(:,3)) mean(AUCband(:,3))-std(AUCband(:,3))],'Color','g')
hold on
line([0 length(AUCband(:,3))],[mean(AUCband(:,3))+std(AUCband(:,3)) mean(AUCband(:,3))+std(AUCband(:,3))],'Color','g')
subplot(2,1,2); plot(ecg_class,'o--'); xlim([0 length(ecg_class)])


%%
figure
subplot(2,1,1); plot(OTHER,'o--'); xlim([0 length(OTHER)])
hold on
line([0 length(OTHER)],[mean(OTHER) mean(OTHER)],'Color','r')
hold on
line([0 length(OTHER)],[mean(OTHER)-std(OTHER) mean(OTHER)-std(OTHER)],'Color','g')
hold on
line([0 length(OTHER)],[mean(OTHER)+std(OTHER) mean(OTHER)+std(OTHER)],'Color','g')
subplot(2,1,2); plot(ecg_class,'o--'); xlim([0 length(ecg_class)])


%%
subplot(2,1,1); plot(predictedClass,'o--'); xlim([0 length(predictedClass)])
subplot(2,1,2); plot(trueClass,'o--'); xlim([0 length(trueClass)])

