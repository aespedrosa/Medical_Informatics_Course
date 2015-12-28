function [pvc pvc_largura pvc_hermite pvc_voted K]=my_pvcdetection(signal,peaks)

% Pela largura dos picos
auc_complexos=[];
for j=1:length(peaks)
    complexoqrs=signal(peaks(j)-fix(0.1*mean(diff(peaks))):peaks(j)+fix(0.1*mean(diff(peaks))));
    auc_complexos=[auc_complexos abs(trapz(complexoqrs))];
end
pvc_largura=[];
for k=1:length(auc_complexos)
    if(auc_complexos(k)>1.4*mean(auc_complexos))
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

% Hermite analise
K=[];
for j=1:length(peaks)
    complexoqrs=signal(peaks(j)-fix(0.1*mean(diff(peaks))):peaks(j)+fix(0.1*mean(diff(peaks))));
    k= hermite(1,complexoqrs);
    K=[K sum((complexoqrs-k).^2)];
end
pvc_hermite=[];
for j=1:length(K)
    if(K(j)>1.4*mean(K))
        pvc_hermite=[pvc_hermite peaks(j)]
    end
end

% Voting
pvc_voted=[];
for v=1:length(peaks)
    voto1=auc_complexos(v)>1.4*mean(auc_complexos);
    voto2=diference(v)<0.7*media;
    voto3=K(v)>1.4*mean(K);
    if((voto1+voto2+voto3)>=2)
        pvc_voted=[pvc_voted peaks(v)];
    end
end

end