% Ruido, PVC, VT

% 1) Localiza??o pico R - ECG
% 2) BPM
% 3) ECG normal --> componentes de freq at? 40Hz
% 4) VT - sinal sinusoidal no tempo, frequencia alta. No dominio da
% frequencia esta frequencia aparece evidente (pico)
% 5) Ru?do --> gama de frequencia mais larga

% Como identificar????
% A) Se tem ru?do, n?o vale a pena analisar
% B) Se n?o tem, detectar PVC e VT

% Sol1) Histograma --> em caso de ru?do, as varia??es est?o mais distribu?das
% Sol2) Filtrar o sinal com filtro passa baixo - obter ECG suave. Fazer diferen?a
% entre o ecg filtrado e original. Se o sinal tiver ru?do, esta diferen?a ?
% muito maior do que se n?o tiver ru?do.
% Sol3) Analisar sinal em janelas de 10s

% Como distinguir PVC?
% 1) N?o existe onda P ou intervalo PR - acontece antes do tempo
% 2) Complexo QRS apresenta uma largura excessiva
% 3) Em frequ?ncia n?o d?.

%----Transforma??es Lineares---- Aula 10/12

% Fun??es de Hermite -- semelhantes ao complexo QRS
% Objectivo: descrever o sinal ecg ? custa das bases de hermite
% X = C . H, sendo X o sinal (10% para a esquerda e direita do pico R), C
% os coeficinentes, H as bases de hermite
% C = H* . X, sendo H* a pseudo inversa de H

% Os coefs da base 0 de hermite s?o diferentes se o complexo QRS 
% for normal ou anormal.

% Sobreposi??o dos picos todos, alinhados pelo picoR, permite clara 
% identifica??o visual dos picos anormais!

%--Dom?nio da frequ?ncia

% RESUMO

% RU?DO
    % TEMPO: Varia??o, Diferen?a (filtro)
    % FREQ: Freqs elevadas (>40Hz)

% PVC 
    % TEMPO: RR, ?rea QRS, Transformadas Hermite

% VTC
    % TEMPO: Numero de batimentos
    % FREQ: Detectar picos, freq de interesse
    