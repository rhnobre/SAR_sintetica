function imgz = contamina_regioes_GA0_indireto(img,N,A,G)
%Função para contaminação de regioes em imagens sintéticas com G-Amplitude
%Zero pelo método indireto
%
%img = imagema ser contaminada. Cada região desta imagem deve ter um único nível de cinza [0 255]
%N = Numero de looks
%A = vetor de alfas
%G = vetor de gamas


I = unique(img);
[X,Y] = size(img);
imgz = zeros(X,Y);
for i = 1:length(I)
    R = ga0([X Y],N,A(i),G(i),1);
    imgz = imgz + (img==I(i)).*R;
end