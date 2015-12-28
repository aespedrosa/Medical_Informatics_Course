function [ predictedClass , CM ] = noiseDetector( trueClass , BPM , DIFF , AUC )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ind1 = (BPM < 20) | (BPM > 200);
ind2 = DIFF > mean(DIFF)+std(DIFF);
ind3 = AUC > nanmean(AUC)+nanstd(AUC);

pred = ind2;




predictedClass = zeros(size(trueClass));
predictedClass(pred==1) = -1;


end

