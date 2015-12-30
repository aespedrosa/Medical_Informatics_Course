function [ BPM , inside , difference , auc , aucband , ratio , sumlower ] = featExtract( ecg_norm , fs )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% Histogram
N = histcounts(diff(ecg_norm),[-0.1 0.1]);
inside = N / length(diff(ecg_norm));

%% BPM
[~ , BPM ] = RPeakDetector( ecg_norm , fs , false , true );

%% Filtering
order = 6;
wc = 30; %Cut-off freq in Hz
fc = wc/(0.5*fs); %Normalized cut-off freq

[b,a] = butter(order,fc,'low');
ecg_filtered = filtfilt(b , a , ecg_norm);

difference = sum( (ecg_norm-ecg_filtered).^2 );

%% Frequency Domain
[Pxx , W] = pburg(ecg_norm,20,0:0.001:pi);
auc = trapz(Pxx);

%% Bands
aucband = zeros(1,4);
aucband(1) = trapz( Pxx(W > pi/fs & W <= 2*pi/fs) );
aucband(2) = trapz( Pxx(W > 2*pi/fs & W <= 6*pi/fs) );
aucband(3) = trapz( Pxx(W > 6*pi/fs & W <= 40*pi/fs) );
aucband(4) = trapz( Pxx(W > 40*pi/fs) );

%% Freq Peak
[~,wp] = max(Pxx);
suplimit = wp + 15;

if suplimit > length(Pxx)
    suplimit = length(Pxx);
end

int1 = trapz(Pxx(wp:suplimit-10));
int2 = trapz(Pxx(wp:suplimit));

ratio = int1 / int2;

%% Other
sumlower = sum(Pxx < 0.1*mean(Pxx));

end

