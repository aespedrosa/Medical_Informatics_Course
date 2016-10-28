function [PVCindexes4] = pvcDetector( ecg , Rindexes )
%pvcDetector Returns the indexes with PVC
% Inputs: 
%   --> ecg - ECG signal
%   --> Rindexes - R peak indexes vector
%
% Outputs:
%   --> PVCindexes4 - vector with PVC indexes

%% RR
D = diff(Rindexes);

mean_dist = mean(D);

PVCindexes1 = Rindexes( [false D < 0.75*mean_dist] );

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

PVCindexes3 = Rindexes( approx_diff > mean(approx_diff)*1.5 );

%% Voting
PVCindexes4 = [];
u1 = union(PVCindexes1,PVCindexes2);
u2 = union(u1,PVCindexes3);

for ind = 1:length(u2)
    if length(find(PVCindexes1==u2(ind))) + length(find(PVCindexes2==u2(ind))) + length(find(PVCindexes3==u2(ind))) > 1
        PVCindexes4 = [PVCindexes4 u2(ind)];
    end
end

end