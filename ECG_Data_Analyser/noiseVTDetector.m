function [ predictedNoiseClass , predictedVTClass ] = noiseVTDetector( trueClass , BPM , HIST , DIFF , AUC , AUCband , RATIOfreq)
%noiseVTDetector Returns the predicted classification for Noise and VT
% Inputs:
%   --> trueClass - window true classification vector
%   --> BPM, HIST, DIFF, AUC, AUCband, RATIOfreq - features
%
% Outputs:
%   --> predictedNoiseClass - window predicted classification vector for
%   noise
%   --> predictedVTClass - window predicted classification vector for VT

predictedNoiseClass = zeros(size(trueClass));
predictedVTClass = zeros(size(trueClass));

%% Noise
ind1a = BPM < mean(BPM) - std(BPM);
ind2 = HIST < mean(HIST) - std(HIST);
ind3 = DIFF > mean(DIFF) + std(DIFF);
ind4 = AUC > mean(AUC) + 1.5*std(AUC);

noise_count = ind1a + ind2 + ind3 + ind4;

predictedNoiseClass(BPM < 15) = 1;
predictedNoiseClass(noise_count >= 2) = 1;

%% VT
ind1b = BPM > mean(BPM) + std(BPM) | BPM > 200;
ind5 = AUCband(:,2) > mean(AUCband(:,2)) + 0.2*std(AUCband(:,2));
ind6 = RATIOfreq > mean(RATIOfreq) + std(RATIOfreq);

vt_count = ind1b + ind5 + ind6;

predictedVTClass(vt_count >= 2) = 1;


end