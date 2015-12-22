%% ---------- ECG Analysis ----------- %%
% -------- Informatica Medica -------- %
% - Alexandre Campos | Andre Pedrosa - %
% --------------- 2015 --------------- %

%% =============== DATA DATPVC =============== %%
% ==================== PVC =================== %

% ----- Load ECG ----- %
clear, clc, close all;

fs = 250;

temp = what(fullfile(pwd,'DATPVC'));
files = fullfile('DATPVC',temp.mat);

load(files{1});

ecg = DAT.ecg;
Rind = DAT.ind;
PVCind = Rind(DAT.pvc==1);

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

%% Preprocessing
[ecg_norm , ecg_pre] = preProcessing( ecg , fs );

%% ===== Feature Extraction and Peak Detection ===== %%
windowsize = 30; %in seconds
window = 1:(windowsize * fs);
maxindex = floor( N / (fs*windowsize) );

RPeakIndexes = zeros(N,1);
PVCPeakIndexes = zeros(N,1);
BPM = zeros(maxindex,1); %BPM per window

for w = 1:maxindex
    sub_ecg = ecg_pre (window);
    
    %---R Peaks and BPM
    [ RwindowIndexes , BPM(w) ] = RPeakDetector( sub_ecg , fs , false );
    
    RPeakIndexes(RwindowIndexes + window(1) - 1) = 1;
    
    %---Area under Curve
    [PVCwindowIndexes1,PVCwindowIndexes2,PVCwindowIndexes3,PVCwindowIndexes4] = ...
                pvcDetector( sub_ecg , RwindowIndexes );
    
    PVCPeakIndexes(PVCwindowIndexes4 + window(1) - 1) = 1;       
            
    window = window + fs*windowsize;
end

%% Comparison ECG, R Peaks, PVC Peaks - With Normalization
figure
    plot(t,ecg_norm,t(RPeakIndexes==1),ecg_norm(RPeakIndexes==1),'o',...
        t(PVCPeakIndexes==1),ecg_norm(PVCPeakIndexes==1),'x')
    legend('ECG (Normalized)','R Peaks','PVC','Location','Southeast');
    xlabel('Time (s)'); ylabel('Amplitude');
    title('PVC Detection')
    xlim([0 max(t)])

%% Comparison ECG, R Peaks, PVC Peaks - With Preprocessing
figure
    plot(t,ecg_pre,t(RPeakIndexes==1),ecg_pre(RPeakIndexes==1),'o',...
        t(PVCPeakIndexes==1),ecg_pre(PVCPeakIndexes==1),'x')
    legend('ECG (Normalized)','R Peaks','PVC','Location','Southeast');
    xlabel('Time (s)'); ylabel('Amplitude');
    title('PVC Detection')
    xlim([0 max(t)])

%% Accuracy R Peaks
trueR = zeros(N,1);
trueR(Rind) = 1;

CM1 = peakComparator( 'R' , trueR , RPeakIndexes , ecg_pre , fs , true);    
    
%% Accuracy PVC
truePVC = zeros(N,1);
truePVC(PVCind) = 1;

CM2 = peakComparator( 'PVC' , truePVC , PVCPeakIndexes , ecg_pre , fs , true);
