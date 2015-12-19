function [ TP , TN , FP , FN ] = peakComparator( truePeaks_index , predictedPeaks_index , ecg , fs , display)
%PEAKCOMPARATOR Summary of this function goes here
%   Detailed explanation goes here

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

truePeaks = zeros(N,1);
predictedPeaks = zeros(N,1);

truePeaks(truePeaks_index+1) = 1;
predictedPeaks(predictedPeaks_index) = 1;

w = 3;

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

if display
    plot(t,ecg,t(truePeaks==1),ecg(truePeaks==1),'o',t(predictedPeaks==1),ecg(predictedPeaks==1),'x');
    legend('ECG','True','Predicted','Location','Southeast')
    title('PVC Detection')
    xlabel('Time (s)')
    ylabel('Amplitude')
    xlim([0 max(t)])
end

end