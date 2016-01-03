%% ---------- ECG Analysis ----------- %%
% -------- Informatica Medica -------- %
% - Alexandre Campos | Andre Pedrosa - %
% ------------- 2015/2016 ------------ %

%% =============== DATA DATARR =============== %%
% ================= Noise / VT =============== %

% ----- Load ECG ----- %
clear, clc, close all;

fs = 125;

temp = what(fullfile(pwd,'DATARR'));
files = fullfile('DATARR',temp.mat);

results_table_noise = zeros(length(files),6);
results_table_VT = zeros(length(files),6);

index = 1;

while index <= length(files)
    fprintf('========== File %s ==========\n',files{index});
    
    [ ecg , ecg_class , N , t ] = loadARRFile( index , fs , files);
    
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
    
    trueClass = zeros(maxindex,1);
    predictedClass = zeros(maxindex,1);
    
    for w = 1:maxindex
        
        [sub_ecg , ~] = preProcessing( ecg(window) , fs );
        
        [ trueClass(w) ] = realClassWindow( ecg_class , trueClass(w) , maxindex , w , window );
        
        [ BPM(w) , HIST(w) , DIFF(w) , ...
            AUC(w) , AUCband(w,:) , RATIOfreq(w)] = featExtract( sub_ecg , fs );
        
        window = window + fs*windowsize;
    end
    
    %% ===== Noise and VT Detector ===== %%
    [predictedNoiseClass , predictedVTClass ] = noiseVTDetector( trueClass , BPM , HIST , DIFF , ...
        AUC , AUCband , RATIOfreq);
    
    %% ===== Accuracy ===== %%
    [results_table_noise(index,:), results_table_VT(index,:)] = windowComparator(trueClass , predictedNoiseClass , predictedVTClass , true, false);
    
    index = index + 1;

    fprintf('============================================\n')

end

%% Display Tables
Noise = table(temp.mat,results_table_noise(:,1),results_table_noise(:,2),results_table_noise(:,3),results_table_noise(:,4),results_table_noise(:,5),results_table_noise(:,6),'VariableNames',{'File' 'TP' 'Detected' 'Real' 'Specificity' 'Sensibility' 'Accuracy'})
VT = table(temp.mat,results_table_VT(:,1),results_table_VT(:,2),results_table_VT(:,3),results_table_VT(:,4),results_table_VT(:,5),results_table_noise(:,6),'VariableNames',{'File' 'TP' 'Detected' 'Real' 'Specificity' 'Sensibility' 'Accuracy'})
