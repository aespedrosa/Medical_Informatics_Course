function [TP,TN,FP,FN,SP,SE]=my_results(target,output)


TP=0;
TN=0;
FP=0;
FN=0;
for i=1:length(target)
    if(target(i)==1 && output(i)==1)
        TP=TP+1;
    elseif(target(i)==0 && output(i)==0)
        TN=TN+1;
    elseif(target(i)==1 && output(i)==0)
        FN=FN+1;
    else
        FP=FP+1;
    end
    
end

SP=100*TN/(TN+FP);
SE=100*TP/(TP+FN);


end