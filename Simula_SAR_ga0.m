%  --- INICIALIZA O PROGRAMA LIMPANDO VARIAVEIS ---
clc;
close all;
clear all;
% -------------------------------------------

% -- PARAMETROS DE GERA��O DA IMAGEM CONTAMINADA --
%zonas extremamente heterogeneas:  ]-5 0[
%zonas heterogeneas             :  [-15 -5]
%zonas homogeneas               :  [-inf -15[
alfa = [-1.4 -7 -12 -16 -20];

arq = strcat ('img_Real.bmp'); 
imagemR = imread(arq);
imagemR=double(imagemR);
    
Nlooks = 1; % N�mero de Visadas (Looks) [1 2 3 4 5 6 7 8]
MGo = 1;    % M�dia da Distribui��o G0;

L = Nlooks; % N�mero de Visadas (Looks)
mi = MGo;   % m�dia da distribui��o G0

% calculando gama a partir da m�dia
for i = 1:size(alfa,2)
    gama(i)=L*((mi*gamma(-alfa(i))*gamma(L))/(gamma(-alfa(i)-0.5)*gamma(L+0.5)))^2;        
end

% informando gama diretamente
% gama = [0.4 6 10 25 60];

imagem_ga0_direto = contamina_regioes_GA0_direto(imagemR,L,alfa,gama);
imagem_ga0_indireto = contamina_regioes_GA0_indireto(imagemR,L,alfa,gama);

figure;
  subplot(1,3,1)
  imshow(imagemR)
  subplot(1,3,2)
  imshow(imagem_ga0_direto)  
  subplot(1,3,3)
  imshow(imagem_ga0_indireto)


