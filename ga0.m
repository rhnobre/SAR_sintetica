function R = ga0(M,N,alfa,gama,gerador)
%Funcao para simular ruido speckle em amplitude
%e multiplas visadas com distribuição G-Amplitude Zero
%
% Ricardo Holanda Nobre
%
%Sintax:
%R = gamaz(M,N,alfa,gama);
%
%M : vetor com as dimensoes da imagem Ex.: M=[100 100];
%N>0 : numero de looks
%alfa<0 : rugosidade
%gama>0: escala
%gerador: se =0, gera pelo método direto, se não gera pelo método indireto

%R : Matriz resultante com o padrao do ruido speckle



if gerador==0
    % usando o método direto    

    U = rand(M);
    U = U(:);
    Z = sqrt(-gama*icdf('f',U,2*N,-2*alfa)/alfa);    
    
    Z = reshape(Z,M(1),M(2));
    r = randperm(M(1)*M(2));
    R = zeros(size(Z));
    r2 = 1:M(1)*M(2);
    R(r2) = Z(r);
    
       
      
    
else
    % usando o método indireto
    Y = random('gam',N,N,[M(1) M(2)]);
    % corrigindo retorno da função gamrnd;
    Y = Y.*(1/N^2);
    
    X = random('gam',-alfa,gama,[M(1) M(2)]);
    % corrigindo retorno da função gamrnd;
    X = X.*(1/gama^2);
    
    Z = sqrt(Y./X);
    
    r = randperm(M(1)*M(2));
    R = zeros(size(Z));
    r2 = 1:M(1)*M(2);
    R(r2) = Z(r);        
        
end


