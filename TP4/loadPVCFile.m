function [ ecg , Rind , PVCind , N , t ] = loadPVCFile( index , fs , files )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load(files{index});

if index == 4
    ecg = - DAT.ecg;
else
    ecg = DAT.ecg;
end

Rind = DAT.ind;
PVCind = Rind(DAT.pvc==1);

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

end