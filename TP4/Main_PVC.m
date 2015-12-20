%% ---------- ECG Analysis ----------- %%
% -------- Informatica Medica -------- %
% - Alexandre Campos | Andre Pedrosa - %
% --------------- 2015 --------------- %

%% =============== DATA DATPVC =============== %%
% ==================== PVC =================== %

% ----- Load ECG ----- %
clear, clc, close all;

fs = 250;

load 'DATPVC/DPVC_106.mat';

ecg = DAT.ecg;
Rind = DAT.ind;
PVCind = Rind(DAT.pvc==1);

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

%% ===== Feature Extraction and Peak Detection ===== %%
windowsize = 5; %in seconds
window = 1:windowsize * fs;
maxindex = floor( N / (fs*windowsize) );

RPeakIndexes = zeros(N,1);
PVCPeakIndexes = zeros(N,1);
BPM = zeros(maxindex,1); %BPM per window

for w = 1:maxindex
    sub_ecg = ecg (window);
    
    %---Preprocess
    sub_ecg_pre = preProcessing( sub_ecg , fs );
    
    %---R Peaks and BPM
    [ RwindowIndexes , BPM(w) ] = RPeakDetector( sub_ecg_pre , fs , false );   
    RPeakIndexes(RwindowIndexes + window(1) - 1) = 1;
    
    %---Area under Curve
    [PVCwindowIndexes1,PVCwindowIndexes2,PVCwindowIndexes3] = ...
                pvcDetector( sub_ecg , RwindowIndexes );
    
    PVCPeakIndexes(PVCwindowIndexes1 + window(1) - 1) = 1;       
            
    window = window + fs*windowsize;
end

%% Comparison
truePVC = zeros(N,1);
truePVC(PVCind) = 1;

[ CM , CM2 ] = peakComparatorV2( truePVC , PVCPeakIndexes , ecg , fs , true);
