%% ---------- ECG Analysis ----------- %%
% -------- Informatica Medica -------- %
% - Alexandre Campos | Andre Pedrosa - %
% ------------- 2015/2016 ------------ %

%% =============== DATA DATPVC =============== %%
% ==================== PVC =================== %

% ----- Load ECG ----- %
clear, clc, close all;

fs = 250;

temp = what(fullfile(pwd,'DATPVC'));
files = fullfile('DATPVC',temp.mat);

results_table_R = zeros(length(files),5);
results_table_PVC = zeros(length(files),5);

index = 1;

while index <= length(files)
    fprintf('========== File %s ==========\n',files{index});
    
    [ ecg , Rind , PVCind , N , t ] = loadPVCFile( index , fs , files );
    
    %% Preprocessing
    [ecg_norm , ecg_pre] = preProcessing( ecg , fs );
    
    %% ===== Feature Extraction and Peak Detection ===== %%
    windowsize = 2600; %in seconds
    window = 1:(windowsize * fs);
    maxindex = floor( N / (fs*windowsize) );
    
    if maxindex<1; disp('Adjust windowsize: too large.'); end
    
    RPeakIndexes = zeros(N,1);
    PVCPeakIndexes = zeros(N,1);
    BPM = zeros(maxindex,1); %BPM per window
    
    for w = 1:maxindex
        sub_ecg = ecg_pre (window);
        
        %---R Peaks and BPM
        [ RwindowIndexes , BPM(w) ] = RPeakDetector( sub_ecg , fs , false );
        
        RPeakIndexes(RwindowIndexes + window(1) - 1) = 1;
        
        %---PVC
        [PVCwindowIndexes] = ...
            pvcDetector( sub_ecg , RwindowIndexes );
        
        PVCPeakIndexes(PVCwindowIndexes + window(1) - 1) = 1;
        
        window = window + fs*windowsize;
    end
    
    %% Accuracy R Peaks
    trueR = zeros(N,1);
    trueR(Rind) = 1;
    
    results_table_R(index,:) = peakComparator( 'R' , trueR , RPeakIndexes , ecg , fs , true , false);
    
    %% Accuracy PVC
    truePVC = zeros(N,1);
    truePVC(PVCind) = 1;
    
    results_table_PVC(index,:) = peakComparator( 'PVC' , truePVC , PVCPeakIndexes , ecg , fs , true , false);
        
    index = index + 1;

    fprintf('============================================\n')
end

%% Display Tables
RPeaks = table(temp.mat,results_table_R(:,1),results_table_R(:,2),results_table_R(:,3),results_table_R(:,4),results_table_R(:,5),'VariableNames',{'File' 'Detected' 'Real' 'Specificity' 'Sensibility' 'Accuracy'})
PVCPeaks = table(temp.mat,results_table_PVC(:,1),results_table_PVC(:,2),results_table_PVC(:,3),results_table_PVC(:,4),results_table_PVC(:,5),'VariableNames',{'File' 'Detected' 'Real' 'Specificity' 'Sensibility' 'Accuracy'})

