function [ ecg , ecg_class , N , t ] = loadARRFile( index , fs , files)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load(files{index});

ecg = DAT.ecg;
ecg_class = DAT.class;

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

end