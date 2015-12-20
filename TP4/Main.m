%% ---------- ECG Analysis ----------- %%
% -------- Informatica Medica -------- %
% - Alexandre Campos | Andre Pedrosa - %
% --------------- 2015 --------------- %

%% =============== DATA DATARR =============== %%
% ============= NOISE AND ARITMIA ============ %

% ----- Load ECG ----- %
clear, clc, close all;

fs = 125;

load 'DATARR/DARR_003.mat';

ecg = DAT.ecg;
ecg_class = DAT.class;

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

%% =============== DATA DATPVC =============== %%
% ==================== PVC =================== %

% ----- Load ECG ----- %
clear, clc, close all;

fs = 250;

load 'DATPVC/DPVC_106.mat';

ecg = DAT.ecg;
Rind = DAT.ind;
PVCind = DAT.pvc;

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

%% ===== Preprocessing ===== %%
ecg_processed = preProcessing( ecg , fs );

%% ===== R Peak Detection ===== %%
[Rindexes , RindexesECG] = RPeakDetector( ecg_processed , fs , false );

% ----- Accuracy ----- %
[TP , TN , FP , FN] = peakComparator( Rind , RindexesECG , ecg_processed , fs , false );

SP = TN * 100 / (TN + FP);
SE = TP * 100 / (TP + FN);
acc = (TP + TN) * 100 / N;
B_acc = (SP + SE) / 2;

fprintf('----- R Peak Detection Accuracy -----\n')
fprintf('TP: %d | TN: %d | FP: %d | FN: %d\n',TP,TN,FP,FN);
fprintf('SP: %0.2f%% | SE: %0.2f%%\n',SP,SE);
fprintf('Accuracy: %0.2f%%\n',acc);
fprintf('Balanced Accuracy: %0.2f%%\n',B_acc);
fprintf('-------------------------------------\n')

%% ===== PVC Detection ===== %%

truePVC = Rind(PVCind==1);

[ PVCindexes ,PVCindexes2 , PVCindexes3] = pvcDetector( ecg_processed , RindexesECG );

[TP , TN , FP , FN] = peakComparator( truePVC , PVCindexes2 , ecg_processed , fs , true );

SP = TN * 100 / (TN + FP);
SE = TP * 100 / (TP + FN);
acc = (TP + TN) * 100 / N;
B_acc = (SP + SE) / 2;

fprintf('----- PVC Detection Accuracy -----\n')
fprintf('TP: %d | TN: %d | FP: %d | FN: %d\n',TP,TN,FP,FN);
fprintf('SP: %0.2f%% | SE: %0.2f%%\n',SP,SE);
fprintf('Accuracy: %0.2f%%\n',acc);
fprintf('Balanced Accuracy: %0.2f%%\n',B_acc);
fprintf('----------------------------------\n')

%% ---------- WORK

%% ===== Noise Detection ===== %%
noiseTrueClass = ecg_class;
noiseTrueClass(noiseTrueClass==4) = 0;

windowsize = 2; %in seconds
window = 1:fs*windowsize;

maxindex = floor(length(ecg) / (fs*windowsize));

bpm = zeros(maxindex,1);
difference = zeros(maxindex,1);
auc = zeros(maxindex,1);
veridict = zeros(maxindex,1);
output = zeros(size(ecg));
v = zeros(maxindex,3);

for i = 1:maxindex
    [bpm(i),difference(i),auc(i),veridict(i),v(i,:)] = noiseDetector(ecg(window),fs);
    output(window) = veridict(i);
    window = window + fs*windowsize; 
end

%%
comparison = noiseTrueClass + output;
length(comparison(comparison==-2)) / length(noiseTrueClass(noiseTrueClass==-1))
(length(comparison(comparison==-2)) + length(comparison(comparison==0))) / length(noiseTrueClass)

figure
hold on
plot(noiseTrueClass,'o'), plot(output,'o')

%% ===== VT Detection ===== %%

windowsize = 5; %in seconds
window = 1:fs*windowsize;

maxindex = floor(length(ecg) / (fs*windowsize));
bpm = zeros(maxindex,1);
veridict = zeros(maxindex,1);
trueClass = zeros(maxindex,1);
auc = zeros(maxindex,1);
output = zeros(size(ecg));

for i = 1:maxindex
    [bpm(i),veridict(i),auc(i)] = vtDetector(ecg(window),fs);
    output(window) = bpm(i);
    trueClass(i) = median(DAT.class(window));
    window = window + fs*windowsize; 
end

plot(output)
