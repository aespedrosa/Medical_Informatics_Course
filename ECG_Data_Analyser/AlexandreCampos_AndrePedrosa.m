%% ---------- ECG Analysis ----------- %%
% -------- Informatica Medica -------- %
% - Alexandre Campos | Andre Pedrosa - %
% ------------- 2015/2016 ------------ %

clear, clc, close all;

my_menu = menu('Choose Program:','PVC Detection','Noise and VT Detection');

if my_menu == 1
    Main_PVC;
else
    Main_ARR;
end