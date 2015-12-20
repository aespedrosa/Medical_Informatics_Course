function [ CM , CM2 ] = peakComparatorV2( truePeaks , predictedPeaks , ecg , fs , display)
%PEAKCOMPARATOR Summary of this function goes here
%   Detailed explanation goes here

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

%% Method 1
CM = confusionmat(truePeaks , predictedPeaks);

%% Method 2

w = 2;

TP = 0; TN = 0;
FP = 0; FN = 0;

for p=w+1:N-w
    
    if truePeaks(p) == 0
        if any(predictedPeaks(p-w : p+w)==1)
            FP = FP + 1;
        else
            TN = TN + 1;
        end        
    else
        if any(predictedPeaks(p-w:p+w)==1)
            TP = TP + 1;
        else
            FN = FN + 1;
        end
    end
   
end

CM2 = [TN FN ; FP TP];

SP = TN * 100 / (TN + FP);
SE = TP * 100 / (TP + FN);
acc = (TP + TN) * 100 / N;
B_acc = (SP + SE) / 2;

fprintf('----- PVC Detection Accuracy -----\n')
fprintf('TP: %d | TN: %d | FP: %d | FN: %d\n',TP,TN,FP,FN);
fprintf('SP: %0.2f%% | SE: %0.2f%%\n',SP,SE);
fprintf('Accuracy: %0.2f%%\n',acc);
fprintf('Balanced Accuracy: %0.2f%%\n',B_acc);
fprintf('----------------------------------\n')

if display
    plot(t,ecg,t(truePeaks==1),ecg(truePeaks==1),'o',t(predictedPeaks==1),ecg(predictedPeaks==1),'x');
    legend('ECG','True','Predicted','Location','Southeast')
    title('PVC Detection')
    xlabel('Time (s)')
    ylabel('Amplitude')
    xlim([0 max(t)])
end

end