function e0=my_normalizar(ecg)

mean_ecg=mean(ecg);
e0=ecg-mean_ecg;
e0=e0/max(e0);

end