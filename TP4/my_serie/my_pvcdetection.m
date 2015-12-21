function [pvc pvc_largura pvc_voted]=my_pvcdetection(signal,peaks)

% Pela largura dos picos
auc_complexos=[];
for j=1:length(peaks)
    complexoqrs=signal(peaks(j)-fix(0.2*mean(diff(peaks))):peaks(j)+fix(0.2*mean(diff(peaks))));
    auc_complexos=[auc_complexos abs(trapz(complexoqrs))];
end
pvc_largura=[];
for k=1:length(auc_complexos)
    if(auc_complexos(k)>1.6*mean(auc_complexos))
        pvc_largura=[pvc_largura peaks(k)];
    end
end

% Pelo intervalo de tempo
diference=diff(peaks);
diference=[0 diference];
media=mean(diference);
pvc=[];
for i=1:length(diference);
    if(diference(i)<0.7*media)
        pvc=[pvc peaks(i)];
    end
end

% Voting
pvc_voted=[];
for v=1:length(peaks)
     if(auc_complexos(v)>1.3*mean(auc_complexos) && diference(v)<0.7*media)
         pvc_voted=[pvc_voted peaks(v)];
     end
end

end