function [ table_row ] = peakComparator(type, truePeaks , predictedPeaks , ecg , fs , displayConsole , displayGraphs)
%PEAKCOMPARATOR Summary of this function goes here
%   Detailed explanation goes here

N = length(ecg);
t = 0:(1/fs):N/fs-(1/fs);

w = 15; % Tolerance in points

TP = 0; FN = 0;

for p=w+1:N-w
    
    if truePeaks(p) == 1
        if any(predictedPeaks(p-w : p+w)==1)
            TP = TP + 1;
        else
            FN = FN + 1;
        end
    end
    
end

detected = sum(predictedPeaks);

FP = detected - TP;
TN = N - TP - FN - FP;

SP = TN * 100 / (TN + FP);
SE = TP * 100 / (TP + FN);
acc = (TP + TN) * 100 / N;
B_acc = (SP + SE) / 2;

table_row = [sum(predictedPeaks) sum(truePeaks) SP SE B_acc];

switch type
    case 'R'
        % Method 1 - For R Peak Comparison
        %         CM = confusionmat(truePeaks , predictedPeaks);
        %
        %         TN = CM(1,1); FN = CM(1,2);
        %         FP = CM(2,1); TP = CM(2,2);
        %
        %         SP = TN * 100 / (TN + FP);
        %         SE = TP * 100 / (TP + FN);
        %         acc = (TP + TN) * 100 / N;
        %         B_acc = (SP + SE) / 2;
        if displayConsole
            fprintf('----- R Peak Detection Accuracy -----\n')
            fprintf('Peaks Detected: %d | True Peaks: %d \n',sum(predictedPeaks),sum(truePeaks));
            fprintf('TP: %d | TN: %d | FP: %d | FN: %d\n',TP,TN,FP,FN);
            fprintf('SP: %0.2f%% | SE: %0.2f%%\n',SP,SE);
            fprintf('Accuracy: %0.2f%%\n',acc);
            fprintf('Balanced Accuracy: %0.2f%%\n',B_acc);
            fprintf('----------------------------------\n')
        end
        
        if displayGraphs
            figure
            plot(t,ecg,t(truePeaks==1),ecg(truePeaks==1),'o',...
                t(predictedPeaks==1),ecg(predictedPeaks==1),'x');
            legend('ECG','True','Predicted','Location','Southeast')
            title('R Peak Detection')
            xlabel('Time (s)')
            ylabel('Amplitude')
            xlim([0 max(t)])
        end
        
    case 'PVC'
        if displayConsole
            fprintf('----- PVC Detection Accuracy -----\n')
            fprintf('Peaks Detected: %d | True Peaks: %d \n',sum(predictedPeaks),sum(truePeaks));
            fprintf('TP: %d | TN: %d | FP: %d | FN: %d\n',TP,TN,FP,FN);
            fprintf('SP: %0.2f%% | SE: %0.2f%%\n',SP,SE);
            fprintf('Accuracy: %0.2f%%\n',acc);
            fprintf('Balanced Accuracy: %0.2f%%\n',B_acc);
            fprintf('----------------------------------\n')
        end
        
        if displayGraphs
            figure
            plot(t,ecg,t(truePeaks==1),ecg(truePeaks==1),'o',...
                t(predictedPeaks==1),ecg(predictedPeaks==1),'x');
            legend('ECG','True','Predicted','Location','Southeast')
            title('PVC Detection')
            xlabel('Time (s)')
            ylabel('Amplitude')
            xlim([0 max(t)])
        end
        
    otherwise
        table_row = [];
        disp('Invalid Type Input.')
end

end