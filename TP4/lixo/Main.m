clear, clc;
close all;

%% Configs
display = true;

%% Load ECG
fs = 1000;

ecg = load('data/a.dat');
ecg = ecg(:,3);

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
    figure(1)
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
    figure(2)
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
    figure(3)
    plot(t,ecg,t,mean_ecg+e2,'g:',t,e3,'m:','LineWidth',1.5)
    title(' DIFFERENTIATION+SQUARE ','FontSize',14)
    zoom on
    %hold on
%     pause
    figure(4)
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
    figure(1)
    plot(t,e0,t,e5,'r','LineWidth',1.5)
    title(' MOVING AVERAGE FILTER ','FontSize',14)
    zoom on
%     pause
end

%% Find R Peaks

max_value = max(e5);
min_value = min(e5);

threshold = 0.65;

e6 = e5;
e6(e6<threshold*max_value) = 0;

d = [ 0 ; diff(e6)];
d(d < max(d)/2 ) = 0;
Rindexes = find(d>0);

%%
figure()
    plot(t,e2)
    hold on
    plot(t(Rindexes),d(Rindexes),'o')

BPM = ( length(Rindexes)*60 ) / max(t);

fprintf('BPM: %0.2f bpm \n',BPM);

