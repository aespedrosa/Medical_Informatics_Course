function [ predictedClass ] = noiseDetectorFull( trueClass , HIST , BPM , DIFF , AUC , AUCband , RATIOfreq , other)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ind0 = HIST < mean(HIST) - std(HIST);
ind1 = BPM < mean(BPM) - std(BPM);
ind2 = DIFF > mean(DIFF) + 0.5*std(DIFF);
ind3 = AUC > mean(AUC) + std(AUC);
ind33 = other < mean(other) - std(other);

ind4 = AUCband(:,3) < mean(AUCband(:,3)) - std(AUCband(:,3));
ind5 = RATIOfreq > mean(RATIOfreq) + std(RATIOfreq);
ind6 = BPM > mean(BPM) + std(BPM);
ind7 = other > mean(other) + std(other);

noise_count = ind0 + ind1 + ind2 + ind3 + ind33;
vt_count = ind4 + ind5 + ind6 + ind7;

predictedClass = zeros(size(trueClass));

predictedClass(vt_count > 2) = 4;
predictedClass(noise_count > 2) = -1;

end