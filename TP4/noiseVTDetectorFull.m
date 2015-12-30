function [ predictedNoiseClass , predictedVTClass ] = noiseVTDetectorFull( trueClass , BPM , HIST , DIFF , AUC , AUCband , RATIOfreq , other)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

predictedNoiseClass = zeros(size(trueClass));
predictedVTClass = zeros(size(trueClass));

%% Noise
ind1a = BPM < mean(BPM) - std(BPM);
ind2 = HIST < mean(HIST) - std(HIST);
ind3 = DIFF > mean(DIFF) + std(DIFF);
ind4 = AUC > mean(AUC) + 1.5*std(AUC);

noise_count = ind1a + ind2 + ind3 + ind4;

predictedNoiseClass(noise_count >= 2) = 1;

%% VT
ind1b = BPM > mean(BPM) + std(BPM);
ind5 = AUCband(:,3) < mean(AUCband(:,3)) - std(AUCband(:,3));
ind6 = RATIOfreq > mean(RATIOfreq) + std(RATIOfreq);
ind7 = other > mean(other) + std(other);

vt_count = ind1b + ind5 + ind6 + ind7;

predictedVTClass(vt_count >= 2) = 1;


end