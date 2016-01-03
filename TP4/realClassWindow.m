function [ trueClass ] = realClassWindow( ecg_class , trueClass , maxindex , w , window)
%realClassWindow Transforms point classification to window classification
% Inputs: 
%   --> ecg_class - ECG classification
%   --> trueClass - window point classification
%   --> maxindex - number of windows
%   --> w - current window
%   --> window - window indexes
%
% Output: 
%   --> trueClass - window classification

Nclass = zeros(maxindex,3);

Nclass(w,:) = sum([ecg_class(window)==0 ecg_class(window)==-1 ecg_class(window)==4]);

if Nclass(w,2) * 2 > Nclass(w,1)
    trueClass = -1;
elseif Nclass(w,3) * 2 > Nclass(w,1)
    trueClass = 4;
end

end