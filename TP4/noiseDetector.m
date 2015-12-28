function [ predictedClass ] = noiseDetector( HIST , BPM , DIFF , AUC , AUCband , RATIOfreq , other)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ind0 = HIST < 0.98;
ind1 = (BPM < 20) | (BPM > 360);
ind2 = DIFF > 0.005;
ind3 = AUC > 28;
ind33 = other < 2000;

ind4 = AUCband(:,2) < 0.5;
ind5 = RATIOfreq > 0.45;
ind6 = (BPM > 120) & (BPM < 360);
ind7 = other > 2700;

noise_count = ind0 + ind1 + ind2 + ind3 + ind33;
vt_count = ind4 + ind5 + ind6 + ind7;

predictedClass = 0;
predictedClass(vt_count > 2 && noise_count <= 2) = 4;
predictedClass(noise_count > 2) = -1;

end

