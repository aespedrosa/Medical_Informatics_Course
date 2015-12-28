function b=my_vtdetection(window,fs)

[Pxx,W]=pburg(window,20);

% banda1=trapz(W(1:4),Pxx(1:4));
% banda2=trapz(W(5:40),Pxx(5:40));
% banda3=trapz(W(41:end),Pxx(41:end));
% bands=[banda1,banda2,banda3];
% 
area_total=0;
for i=1:length(W)-1
    area_i=trapz(W(i:i+1),Pxx(i:i+1));
    area_total=area_total+area_i;   
end

area_i=0;
b=0;
for i=1:length(W)-1
    area_i=area_i+trapz(W(i:i+1),Pxx(i:i+1));
    if(area_i>area_total/2)
        b=i;
        break;
    end
end

end
