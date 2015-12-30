%% ---------- ECG Analysis ----------- %%
% -------- Informatica Medica -------- %
% - Alexandre Campos | Andre Pedrosa - %
% --------------- 2015 --------------- %

%% =============== DATA DATARR =============== %%
% ================= Noise / VT =============== %

% ----- Load ECG ----- %
clear, clc, close all;

fs = 125;

temp = what(fullfile(pwd,'DATARR'));
files = fullfile('DATARR',temp.mat);

results_table_noise = zeros(length(files),5);
results_table_VT = zeros(length(files),5);

index = 1;

while index < length(files)
    fprintf('========== File %s ==========\n',files{index});
    [ ecg , ecg_class , N , t ] = loadARRFile( index , fs , files);
    
    %% Preprocessing
    % [ecg_norm , ecg_pre] = preProcessing( ecg , fs );
    
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
    S_LOWER = zeros(maxindex,1);
    
    trueClass = zeros(maxindex,1);
    predictedClass = zeros(maxindex,1);
    Nclass = zeros(maxindex,3);
    
    for w = 1:maxindex
        
        [sub_ecg , ~] = preProcessing( ecg(window) , fs );
        
        %     sub_ecg = ecg_norm (window);
        
        Nclass(w,:) = sum([ecg_class(window)==0 ecg_class(window)==-1 ecg_class(window)==4]);
        
        if Nclass(w,2) * 2 > Nclass(w,1)
            trueClass(w) = -1;
        elseif Nclass(w,3) * 2 > Nclass(w,1)
            trueClass(w) = 4;
        end
        
        [ BPM(w) , HIST(w) , DIFF(w) , ...
            AUC(w) , AUCband(w,:) , RATIOfreq(w) , S_LOWER(w)] = ...
            featExtract( sub_ecg , fs );
        
        predictedClass(w) = noiseDetector(HIST(w) , BPM(w) , ...
            DIFF(w) , AUC(w) ,AUCband(w,:) , RATIOfreq(w) , S_LOWER(w));
        
        window = window + fs*windowsize;
    end
    
    %% ===== Noise and VT Detector ===== %%
    [predictedNoiseClass , predictedVTClass ] = noiseVTDetectorFull( trueClass , BPM , HIST , DIFF , ...
        AUC , AUCband , RATIOfreq , S_LOWER);
    
    %% ===== Accuracy ===== %%
    [results_table_noise(index,:), results_table_VT(index,:)] = windowComparator(trueClass , predictedNoiseClass , predictedVTClass , true, false);
    
    index = index + 1;

    fprintf('============================================\n')
end

%% Display Tables
Noise = table(temp.mat,results_table_noise(:,1),results_table_noise(:,2),results_table_noise(:,3),results_table_noise(:,4),results_table_noise(:,5),'VariableNames',{'File' 'Detected' 'Real' 'Specificity' 'Sensibility' 'Accuracy'})
VT = table(temp.mat,results_table_VT(:,1),results_table_VT(:,2),results_table_VT(:,3),results_table_VT(:,4),results_table_VT(:,5),'VariableNames',{'File' 'Detected' 'Real' 'Specificity' 'Sensibility' 'Accuracy'})



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
subplot(2,1,2); plot(trueClass,'o--'); xlim([0 length(trueClass)])

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
subplot(2,1,1); plot(S_LOWER,'o--'); xlim([0 length(S_LOWER)])
hold on
line([0 length(S_LOWER)],[mean(S_LOWER) mean(S_LOWER)],'Color','r')
hold on
line([0 length(S_LOWER)],[mean(S_LOWER)-std(S_LOWER) mean(S_LOWER)-std(S_LOWER)],'Color','g')
hold on
line([0 length(S_LOWER)],[mean(S_LOWER)+std(S_LOWER) mean(S_LOWER)+std(S_LOWER)],'Color','g')
subplot(2,1,2); plot(ecg_class,'o--'); xlim([0 length(ecg_class)])


%%
subplot(2,1,1); plot(predictedClass,'o--'); xlim([0 length(predictedClass)])
subplot(2,1,2); plot(trueClass,'o--'); xlim([0 length(trueClass)])

