function [ Rindexes ] = RPeakDetector( ecg , fs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

e2 = ecg;
display = false;

N = length(ecg);

t = 0:(1/fs):N/fs-(1/fs);

%% Difference + Square
e3 = diff(e2);
e3(end+1) = e2(end);

e4 = 50*e3.^2;
if display
    figure
    plot(t,ecg,t,mean_ecg+e2,'g:',t,e3,'m:','LineWidth',1.5)
    title(' DIFFERENTIATION+SQUARE ','FontSize',14)
    zoom on
    
    figure
    plot(t,e4,'r','LineWidth',1.5)
    title(' DIFFERENTIATION+SQUARE ','FontSize',14)
    zoom on

end

%% Moving Average
timew = 0.22; %Window
Nw = fix(timew*fs);    % samplings (even)

b = (1/Nw)*ones(1,Nw);
a = 1;

e5= 10*filtfilt(b,a, e4);

if display
    figure()
    plot(t,e0,t,e5,'r','LineWidth',1.5)
    title(' MOVING AVERAGE FILTER ','FontSize',14)
    zoom on
end

%% Find R Peaks in Energy
Rindexes = [];
threshold = 0.5 * mean(e5);

for i=2:length(e5)-1
   if (e5(i) > threshold && e5(i-1) < e5(i) && e5(i+1) < e5(i))
       Rindexes = [Rindexes i];
   end
end
    
% figure()
%     plot(t,e5, ...
%         t(Rindexes),e5(Rindexes),'o');
%     legend('Energy','R Peaks');
%     title('R Peaks Detection');
%     xlabel('Time (s)')
%     grid on

%% Find R Peaks in ECG
% RindexesECG = zeros(size(Rindexes));
% w = round(0.5 * mean(diff(Rindexes)));
% 
% for p=1:length(Rindexes)
%     temp = find(e2==max(e2(Rindexes(p)-w : Rindexes(p)+w)));    
%     if length(temp) > 1
%         RindexesECG(p) = Rindexes(p);
%     end
% end
%     
% figure()
%     plot(t,e2, ...
%         t(RindexesECG),e2(RindexesECG),'o');
%     legend('Preprocessed ECG','R Peaks');
%     title('R Peaks Detection');
%     xlabel('Time (s)')
%     grid on

BPM = ( length(Rindexes)*60 ) / max(t);

fprintf('BPM: %0.2f bpm \n',BPM);


end

