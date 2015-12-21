%% ------------------ ECG - PVC detection --------------------- %%
% --------- Informática Clínica e Sisitemas de Telesaúde ------- %
% ------------- Alexandre Sayal / André Pedrosa ---------------- %

%% Load ECG Signal
ecg_all=load('DATPVC_serie/DPVC_119.mat');
ecg=ecg_all.DAT.ecg;
fs=250;
N=length(ecg);
t=0:(1/fs):(N-1)/fs;

%% Normalizar
e1=my_normalizar(ecg);

%% Filtragem
%e2=my_filtragem(signal,40,1);

%% Detecar os batimentos
batimentos_ind=my_batdetection(e1,fs);

%% Detectar as pvc's
[pvc pvc_largura pvc_voted]=my_pvcdetection(e1,batimentos_ind);
figure();
plot(t,e1);
hold on;
plot(t(batimentos_ind),e1(batimentos_ind),'r.');
hold on;
plot(t(pvc_voted),e1(pvc_voted),'.');
hold on;
plot(t(ecg_all.DAT.ind(ecg_all.DAT.pvc==1)),e1(ecg_all.DAT.ind(ecg_all.DAT.pvc==1)),'g.');

acerto=my_pvcresults(pvc_voted,ecg_all.DAT.ind(ecg_all.DAT.pvc==1));