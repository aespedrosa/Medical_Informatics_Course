function real_peak=my_batdetection(signal,fs)
% Difference + Square
signal_diff=diff(signal);
signal_diff(end+1)=signal(end);
signal_square= 50*signal_diff.^2;

% Moving Average
timew= 0.05;
Nw= fix(timew*fs);
b = (1/Nw)*ones(1,Nw);
a = 1;
signal_averaged= 10*filtfilt(b,a, signal_square);

%Peak Detection
mean_energy=mean(signal_averaged);
threshold=mean_energy*0.7;
peaks=[];
for i=2:length(signal_averaged)-1
    if(signal_averaged(i)>threshold && signal_averaged(i)>signal_averaged(i-1) && signal_averaged(i)>signal_averaged(i+1))
        peaks=[peaks i];
    end
end

real_peak=[];
if(length(peaks)>1)
    difere=diff(peaks);
    step=fix(mean(difere)/2);
    for j=1:length(peaks)
        inferior=(peaks(j)-step);
        superior=(peaks(j)+step);
        if(inferior<1)
            inferior=1;
        end
        if(superior>length(signal))
            superior=length(signal);
        end
        janela=signal(inferior:superior);
        [~,max_janela]=max(janela);
        real_peak=[real_peak max_janela+inferior];
    end
    real_peak=real_peak-1;
end


end