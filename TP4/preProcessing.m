function [ e0 , ecg_processed ] = preProcessing( ecg , fs )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

display = false;

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
    figure
    plot(t,e0,t,e1,'r','LineWidth',1.5)
    title(' LOW PASS FILTER ','FontSize',14)
    zoom on
end

%% High Pass Filter
wc = 5;
fc = wc/(0.5*fs);

[b,a] = butter(order,fc,'high');
e2 = filtfilt( b , a , e1 );

if display
    figure
    plot(t,e0,t,e1,'r:',t,e2,'g','LineWidth',1.5)
    title(' HIGH+LOW PASS FILTER ','FontSize',14)
    zoom on
end

ecg_processed = e2;

end

