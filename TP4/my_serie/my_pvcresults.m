function acerto=my_pvcresults(pred,real)
acerto=0;

for i=1:length(real)
    a=(real(i)-5):(real(i)+5);
    if(sum(ismember(a,pred))>0)
            acerto=acerto+1;
    end
end