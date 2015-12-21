function real_peak=my_batdetection(signal,fs)
% Difference + Square
signal_diff=diff(signal);
signal_diff(end+1)=signal(end);
signal_square= 50*signal_diff.^2;

% Moving Average
timew= 0.22;
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

difere=diff(peaks);
step=fix(mean(difere)/2);
real_peak=[];

for j=1:length(peaks)
    janela=signal((peaks(j)-step):(peaks(j)+step));
    coiso=find(janela==max(janela))
    real_peak=[real_peak +coiso(1)+peaks(j)-step];
end

real_peak=real_peak-1;

end