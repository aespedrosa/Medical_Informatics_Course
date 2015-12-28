function e2=my_filtragem(e0,fs,f_top,f_down)

% Filtro Passa Baixo
ordem=4;
wc=f_top;
fc=wc/(0.5*fs);
[b,a]=butter(ordem,fc);
e1=filtfilt(b,a,e0);

% Filtro Passa Alto
ordem=4;
wc=f_down;
fc=wc/(0.5*fs);
[b,a]=butter(ordem,fc,'high');
e2= filtfilt(b,a, e1);

end