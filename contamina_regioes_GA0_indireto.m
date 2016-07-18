function imgz = contamina_regioes_GA0_indireto(img,N,A,G)
%Fun��o para contamina��o de regioes em imagens sint�ticas com G-Amplitude
%Zero pelo m�todo indireto
%
%img = imagema ser contaminada. Cada regi�o desta imagem deve ter um �nico n�vel de cinza [0 255]
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