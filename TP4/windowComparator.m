function [ table_row_noise , table_row_vt ] = windowComparator( trueClass , predictedNoiseClass , predictedVTClass , displayConsole , displayGraphs)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    displayConsole = false;
    displayGraphs = false;
end

trueNoiseClass = trueClass;
trueVTClass = trueClass;

trueNoiseClass (trueNoiseClass == 4) = 0;
trueNoiseClass (trueNoiseClass == -1) = 1;

trueVTClass (trueVTClass == -1) = 0;
trueVTClass (trueVTClass == 4) = 1;

%% Noise
CM = confusionmat(trueNoiseClass , predictedNoiseClass);

TN = CM(1,1); FP = CM(1,2);
FN = CM(2,1); TP = CM(2,2);

SP = TN * 100 / (TN + FP);
SE = TP * 100 / (TP + FN);

B_acc = (SP + SE) / 2;

table_row_noise = [sum(predictedNoiseClass) sum(trueNoiseClass) SP SE B_acc];

if displayConsole
    fprintf('----- Noise Detection Accuracy -----\n')
    fprintf('Detected: %d | True: %d \n',sum(predictedNoiseClass),sum(trueNoiseClass));
    fprintf('TP: %d | TN: %d | FP: %d | FN: %d\n',TP,TN,FP,FN);
    fprintf('SP: %0.2f%% | SE: %0.2f%%\n',SP,SE);
    fprintf('Balanced Accuracy: %0.2f%%\n',B_acc);
    fprintf('------------------------------------\n')
end

if displayGraphs
    figure
    plot(trueNoiseClass,'o-')
    hold on
    plot(predictedNoiseClass,'x')
end

%% VT
CM2 = confusionmat(trueVTClass , predictedVTClass);

TN = CM2(1,1); FP = CM2(1,2);
FN = CM2(2,1); TP = CM2(2,2);

SP = TN * 100 / (TN + FP);
SE = TP * 100 / (TP + FN);

B_acc = (SP + SE) / 2;

table_row_vt = [sum(predictedVTClass) sum(trueVTClass) SP SE B_acc];

if displayConsole
    fprintf('----- VT Detection Accuracy -----\n')
    fprintf('Detected: %d | True: %d \n',sum(predictedVTClass),sum(trueVTClass));
    fprintf('TP: %d | TN: %d | FP: %d | FN: %d\n',TP,TN,FP,FN);
    fprintf('SP: %0.2f%% | SE: %0.2f%%\n',SP,SE);
    fprintf('Balanced Accuracy: %0.2f%%\n',B_acc);
    fprintf('---------------------------------\n')
end

if displayGraphs
    figure
    plot(trueVTClass,'o-')
    hold on
    plot(predictedVTClass,'x')
end

end

