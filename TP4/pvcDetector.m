function [PVCindexes1 , PVCindexes2 , PVCindexes3 , PVCindexes4] = pvcDetector( ecg , Rindexes )
%PVCDETECTOR Summary of this function goes here
%   Detailed explanation goes here

% Data Source: DATPVC

% Largura QRS
% Intervalo RR

%% RR
D = diff(Rindexes);

mean_dist = mean(D);

PVCindexes1 = Rindexes( [false D < 0.7*mean_dist] );

%% Width QRS
area = zeros(size(Rindexes));
N = length(ecg);

w = round(0.1 * mean_dist);

for p=1:length(Rindexes)
    inf_limit = Rindexes(p)-w;
    sup_limit = Rindexes(p)+w;
    
    if (inf_limit < 1); inf_limit = 1; end
    if (sup_limit > N); sup_limit = N; end
    
    sub_ecg = abs(ecg(inf_limit : sup_limit));
    
    area(p) = trapz(sub_ecg);
end

mean_area = mean(area);

PVCindexes2 = Rindexes( area > 1.5*mean_area);

%% Hermite

approx_diff = zeros(size(Rindexes));

for p=1:length(Rindexes)
    inf_limit = Rindexes(p)-w;
    sup_limit = Rindexes(p)+w;
    
    if (inf_limit < 1); inf_limit = 1; end
    if (sup_limit > N); sup_limit = N; end
    
    sub_ecg = ecg(inf_limit : sup_limit);
    
    h = hermite(1,sub_ecg);
    
    approx_diff(p) = sum((sub_ecg-h).^2);
end

PVCindexes3 = Rindexes( approx_diff > mean(approx_diff)*1.1 );

%% Union
i1 = intersect(PVCindexes1,PVCindexes3);
i2 = intersect(PVCindexes1,PVCindexes2);
i3 = intersect(PVCindexes2,PVCindexes3);
u1 = union(i1,i2);
PVCindexes4 = union(u1,i3);

end