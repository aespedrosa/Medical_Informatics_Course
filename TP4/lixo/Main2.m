clear, clc;
close all;

%% Configs
display = false;

%% Load ECG
fs = 250;

% ecg = load('data/ecgPVC.dat');

load 'DATPVC/DPVC_106.mat';

ecg = DAT.ecg(30000:40000);

N = length(ecg);

t = 0:(1/fs):N/fs-(1/fs);

%% Normalization
mean_ecg = mean(ecg);
e0 = ecg - mean_ecg;
e0 = e0 / max(e0);

%% Low Pass Filter
order = 4;
wc = 25; %Cut-off freq in Hz
fc = wc/(0.5*fs); %Normalized cut-off freq

[b,a] = butter(order,fc);
e1 = filtfilt(b , a , e0);

if display
    figure()
    plot(t,e0,t,e1,'r','LineWidth',1.5)
    title(' LOW PASS FILTER ','FontSize',14)
    zoom on
%     pause
end

%% High Pass Filter
wc = 5;
fc = wc/(0.5*fs);

[b,a] = butter(order,fc,'high');
e2 = filtfilt( b , a , e1 );

if display
    figure()
    plot(t,e0,t,e1,'r:',t,e2,'g','LineWidth',1.5)
    title(' HIGH+LOW PASS FILTER ','FontSize',14)
    zoom on
%     pause
end


%% Difference + Square
e3 = diff(e2);
e3(end+1) = e2(end);

e4 = 50*e3.^2;
if display
    figure()
    plot(t,ecg,t,mean_ecg+e2,'g:',t,e3,'m:','LineWidth',1.5)
    title(' DIFFERENTIATION+SQUARE ','FontSize',14)
    zoom on
    %hold on
%     pause
    figure()
    plot(t,e4,'r','LineWidth',1.5)
    title(' DIFFERENTIATION+SQUARE ','FontSize',14)
    zoom on
%     pause
%     hold off
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

%% Find R Peaks 
Rindexes = [];
threshold = 0.5 * mean(e5);

for i=2:length(e5)-1
   if (e5(i) > threshold && e5(i-1) < e5(i) && e5(i+1) < e5(i))
       Rindexes = [Rindexes i];
   end
end

figure()
    plot(t,e5)
    hold on
    plot(t(Rindexes),e5(Rindexes),'o')

BPM = ( length(Rindexes)*60 ) / max(t);

fprintf('BPM: %0.2f bpm \n',BPM);

%% Find PVC

D = diff(Rindexes);

mean_dist = mean(D);

PVCindexes = Rindexes([ false D<mean_dist*0.8 ]);

figure()
    plot(t,e5, ...
        t(Rindexes),e5(Rindexes),'o',...
        t(PVCindexes),e5(PVCindexes),'go');
    legend('Energy','R Peaks','PVC');
    title('PVC Detection');
    xlabel('Time (s)')
    grid on
    
    
    