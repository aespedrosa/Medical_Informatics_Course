%% ------------------ ECG - PVC detection --------------------- %%
% --------- Informática Clínica e Sistemas de Telesaúde -------- %
% ------------- Alexandre Sayal / André Pedrosa ---------------- %
clear all;
clc;

%% Load ECG Signal
ecg_all=load('DATPVC_serie/DPVC_203.mat');
ecg=ecg_all.DAT.ecg;
%ecg_all=load('ecgPVC.dat');
%ecg=ecg_all;
fs=250;
N=length(ecg);
t=0:(1/fs):(N-1)/fs;

%% Normalizar
e1=my_normalizar(ecg);

%% Filtragem
e1=my_filtragem(e1,fs,45,2);

%% Detecar os batimentos
batimentos_ind=my_batdetection(e1,fs);
nr_batimentos=length(ecg_all.DAT.pvc);
figure();
plot(t,e1);
hold on;
plot(t(batimentos_ind),e1(batimentos_ind),'gx');
hold on;
plot(t(ecg_all.DAT.ind),e1(ecg_all.DAT.ind),'r.');
title('Batimentos');
legend('ECG signal','Batimentos Detectados','Batimentos Reais')

%% Detectar as pvc's
[pvc_diftempo pvc_larguraqrs pvc_hermite pvc_voted]=my_pvcdetection(e1,batimentos_ind);
nr_pvc=sum(ecg_all.DAT.pvc==1);
figure();
plot(t,e1);
hold on;
plot(t(pvc_hermite),e1(pvc_hermite),'x');
hold on;
plot(t(ecg_all.DAT.ind(ecg_all.DAT.pvc==1)),e1(ecg_all.DAT.ind(ecg_all.DAT.pvc==1)),'go');
title('PVC´s');
legend('ECG signal','PVC´s Detectados','PVC´s Reais')

%% Results Analise
acerto=my_pvcresults(pvc_diftempo,ecg_all.DAT.ind(ecg_all.DAT.pvc==1));