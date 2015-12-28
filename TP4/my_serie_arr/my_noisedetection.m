function saida=my_noisedetection(window,fs) % class=1 ruido ; class=0 limpo
% Aproximação de filtragem
warning('off','all');
ordem=4;
wc=40;
fc=wc/(0.5*fs);
[b,a]=butter(ordem,fc);
signal_filtrado=filtfilt(b,a,window);
difference=sum((window-signal_filtrado).^2);

% Nº Batimentos
[real_peaks]=my_batdetection(window,fs);
t=0:(1/fs):(length(window)-1)/fs;
bpm=(length(real_peaks)/t(end))*60;

% Variações/Histograma
[N,EDGES] = histcounts(diff(window),[-0.1 0.1]); 
no_noise_count=N/length(diff(window));

% Voting
vote1=difference>0.005;
vote2=bpm<10 || bpm>220;
vote3=no_noise_count<0.98;

if((vote1 +vote2 +vote3)>=2)
    class=1;
else
    class=0;
end

saida=[vote1,difference,vote2,bpm,vote3,no_noise_count,class];

end