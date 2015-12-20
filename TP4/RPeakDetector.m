function [ RindexesECG , BPM ] = RPeakDetector( ecg , fs , display )
%RPEAKDETECTOR Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    display = false;
end

e2 = ecg;

N = length(ecg);

t = 0:(1/fs):N/fs-(1/fs);

%% Difference + Square
e3 = diff(e2);
e3(end+1) = e2(end);

e4 = 50*e3.^2;

%% Moving Average
timew = 0.22; %Window
Nw = fix(timew*fs);    % samplings (even)

b = (1/Nw)*ones(1,Nw);
a = 1;

e5= 10*filtfilt(b,a, e4);

%% Find R Peaks in Energy
Rindexes = [];
% threshold = mean(e5)-0.5*std(e5);
threshold = 0.7*mean(e5);

for i=2:length(e5)-1
   if (e5(i) > threshold && e5(i-1) < e5(i) && e5(i+1) < e5(i))
       Rindexes = [Rindexes i];
   end
end

if display
    figure()
        plot(t,e5, ...
            t(Rindexes),e5(Rindexes),'o');
        legend('Energy','R Peaks');
        title('R Peaks Detection');
        xlabel('Time (s)')
        grid on 
end

%% Find R Peaks in ECG
RindexesECG = zeros(size(Rindexes));

w = round(0.25 * mean(diff(Rindexes)));

for p=1:length(Rindexes)
    inf_limit = Rindexes(p)-w;
    sup_limit = Rindexes(p)+w;
    
    if (inf_limit < 1); inf_limit = 1; end
    if (sup_limit > N); sup_limit = N; end  
    
    sub_e2 = e2(inf_limit : sup_limit);
    
    [~,temp] = max(sub_e2);
    
    RindexesECG(p) = temp + inf_limit - 1;
end
    
if display
    figure()
    plot(t,e2, ...
        t(RindexesECG),e2(RindexesECG),'o');
    legend('Preprocessed ECG','R Peaks');
    title('R Peaks Detection');
    xlabel('Time (s)')
    grid on
end

BPM = ( length(RindexesECG)*60 ) / max(t);

if display
    fprintf('BPM: %0.2f bpm \n',BPM);
end

end