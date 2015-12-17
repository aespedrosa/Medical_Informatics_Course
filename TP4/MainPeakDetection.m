clear, clc;
close all;

%% Load ECG
% fs = 1000;
fs = 125;
load 'DATARR/DARR_019.mat';
% ecg = load('data/a.dat');
% ecg = ecg(:,3);

ecg = DAT.ecg;

N = length(ecg);

t = 0:(1/fs):N/fs-(1/fs);

%% Preprocessing

ecg_processed = preProcessing(ecg , fs);

%% R Peak Detection
Rindexes = RPeakDetector(ecg_processed , fs);

%% ------- WORK

%% Noise Detection
windowsize = 2; %in seconds
window = 1:fs*windowsize;

maxindex = floor(length(ecg) / (fs*windowsize));

inside = zeros(maxindex,1);
bpm = zeros(maxindex,1);
difference = zeros(maxindex,1);
veridict = zeros(maxindex,1);
output = zeros(size(ecg));
v = zeros(maxindex,3);

for i = 1:maxindex
    [inside(i),bpm(i),difference(i),veridict(i),v(i,:)] = noiseDetector(ecg(window),fs);
    output(window) = veridict(i);
    window = window + fs*windowsize; 
end

