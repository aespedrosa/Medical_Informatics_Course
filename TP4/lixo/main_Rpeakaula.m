clear
warning off
%....................
clc
disp(' ')
disp('==========================================================================')
disp('------------------------------------------------------------ ')
disp(' ')
disp(' ')
 

close all
clf
display=1;    %.. visualizar resultados itnermedios

%------------------------------- load ECG
fs=1000;      
ecg=load('data/a.dat');
ecg=ecg(:,3);
N=length(ecg);
t=0:(1/fs):N/fs-(1/fs);


%------------------------------- maximizar janela
fig=gcf;
units=get(fig,'units');
set(fig,'units','normalized','outerposition',[0 0 1 1]);
set(fig,'units',units);


%==========================================================================
% INICIO 
%==========================================================================0
%==========================================================================0
%------------------------------------------------------------ Normalizacao

%???????????????????????????????????????? [min,max]  [-1..1]
mecg=mean(ecg);
e0 = ecg-mecg;
e0 = e0/max(e0);

%???????????????????????????????????????? filtro
%e0=ecg;

%==========================================================================1
%------------------------------------------------------------ LowPass Filter
ordem=4;
wc=25;
fc=wc/(0.5*fs);
[b,a]=butter(ordem,fc);
e1= filter(b,a, e0);
if display
    figure(1)
    plot(t,e0,t,e1,'r','LineWidth',1.5)
    title(' LOW PASS FILTER ','FontSize',14)
    zoom on
    pause
end

%==========================================================================2
%---------------------------------------------------------- High Pass Filter
wc=5;
fc=wc/(0.5*fs);
[b,a]=butter(ordem,fc,'high');
e2= filter(b,a, e1);
if display
    figure(1)
    plot(t,e0,t,e1,'r:',t,e2,'g','LineWidth',1.5)
    title(' HIGH+LOW PASS FILTER ','FontSize',14)
    zoom on
    pause
end

%==========================================================================3
%------------------------------------------------------- Difference + Square
e3= diff(e2);
e3(end+1)=e2(end);

e4= 50*e3.^2;
if display
    figure(1)
    plot(t,ecg,t,mecg+e2,'g:',t,e3,'m:','LineWidth',1.5)
    title(' DIFFERENTIATION+SQUARE ','FontSize',14)
    zoom on
    %hold on
    pause
    figure(1)
    plot(t,e4,'r','LineWidth',1.5)
    title(' DIFFERENTIATION+SQUARE ','FontSize',14)
    zoom on
    pause
    hold off
end

%==========================================================================3
%------------------------------------------------------------ Moving Window
timew= 0.22;
Nw= fix(timew*fs);    % samplings (even)
b = (1/Nw)*ones(1,Nw);
a = 1;
e5= 10*filter(b,a, e4);
if display
    figure(1)
    plot(t,e0,t,e5,'r','LineWidth',1.5)
    title(' MOVING AVERAGE FILTER ','FontSize',14)
    zoom on
    pause
end
%==========================================================================3

