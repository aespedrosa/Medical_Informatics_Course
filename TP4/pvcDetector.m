function [PVCindexes , PVCindexes2 , PVCindexes3] = pvcDetector( ecg , Rindexes )
%PVCDETECTOR Summary of this function goes here
%   Detailed explanation goes here

% Data Source: DATPVC

% Largura QRS
% Intervalo RR

%% RR
D = diff(Rindexes);

mean_dist = mean(D);

PVCindexes = Rindexes( [false D<=0.75*mean_dist] );

%% Width QRS
area = zeros(size(Rindexes));

w = round(0.2 * mean_dist);
N = length(ecg);

for p=1:length(Rindexes)
    inf_limit = Rindexes(p)-w;
    sup_limit = Rindexes(p)+w;
    
    if (inf_limit < 1); inf_limit = 1; end
    if (sup_limit > N); sup_limit = N; end
    
    sub_ecg = abs(ecg(inf_limit : sup_limit));
    
    area(p) = trapz(sub_ecg);
end

mean_area = mean(area);
std_area = std(area);

PVCindexes2 = Rindexes( area > mean_area-std_area );

%% Union
PVCindexes3 = union(PVCindexes,PVCindexes2);

end