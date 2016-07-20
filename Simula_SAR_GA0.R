#########################################
# GERAÇÃO DE IMAGEM SAR SINTÉTICA       #
#   USANDO A DISTRIBUIÇÃO GA0           #
#   Métodos Direto e Indireto           #
#                                       #
#########################################

library(pixmap)

ga0 <- function (M,N,alfa,gama,gerador){
# Funcao para simular ruido speckle em amplitude
# e multiplas visadas com distribuição G-Amplitude Zero
# 
# Autor: Ricardo Holanda Nobre
# 
# Sintax:
#  R = gamaz(M,N,alfa,gama);
#  
#  M : vetor com as dimensoes da imagem Ex.: M=[100 100];
#  N>0 : numero de looks
#  alfa<0 : rugosidade
#  gama>0: escala
#  gerador: se =0, gera pelo método direto, se não gera pelo método indireto
  
#  R : Matriz resultante com o padrao do ruido speckle
  
  r = M[1]
  c = M[2]
   
  if (gerador==0) {
  # usando o método direto    
    U<-runif(r*c,0,1)
    aux1<-qf(U,2*N,-2*alfa) #icdf('f',U1,2*L,-2*alfa)
    Z_amp_dir=sqrt((-gama/alfa)*aux1)
    R=matrix(Z_amp_dir, r,c)
  }
  
  else {
    # usando o método indireto
    aux1<-rgamma(r*c,-alfa,gama)
    X<-sqrt(1/aux1)
    Y<-sqrt(rgamma(r*c,N,N))
    Z_amp_ind=X*Y     
    R=matrix(Z_amp_ind, r,c)
  
  }
  return(R)
}

imgz_direta <- function (img,N,A,G){
# Função para contaminação de regioes em imagens sintéticas com G-Amplitude
# Zero pelo método direto
# 
# img = imagema ser contaminada. Cada região desta imagem deve ter um único nível de cinza [0 255]
# N = Numero de looks
# A = vetor de alfas
# G = vetor de gamas

  # determina a quantidade de nivel de cinza da imagem
  aux = as.vector(img)
  I = unique(aux);
  
  # obtem e armazena as dimensões da imagem
  M = dim(img)
  
  # gera uma matriz de zeros do mesmo tamanho da imagem 
  imgz = matrix(0, M[1], M[2])
  
  # Para cada nível de cinza é gerado uma região da imagem SAR, conforme os parâmetros informados
  for (i in 1:length(I)){
    # gera os dados SAR por região (determinada pelo nível de cinza da imagem) 
    R = ga0(M,N,A[i],G[i],0)
	
	# Aplica os dados SAR apenas sobre a região determinada pelo nível de cinza
    imgaux = ((img==I[i])*R)
	
	# Monta a imagem SAR resultante com os fragmentos das regiões geradas
    imgz = imgz + imgaux
  }
  
  return(imgz)

}

imgz_indireta <- function (img,N,A,G){
# Função para contaminação de regioes em imagens sintéticas com G-Amplitude
# Zero pelo método indireto
# 
# img = imagema ser contaminada. Cada região desta imagem deve ter um único nível de cinza [0 255]
# N = Numero de looks
# A = vetor de alfas
# G = vetor de gamas


  # determina a quantidade de nivel de cinza da imagem
  aux = as.vector(img)
  I = unique(aux);
  
  
  # obtem e armazena as dimensões da imagem
  M = dim(img)
  
  # gera uma matriz de zeros do mesmo tamanho da imagem 
  imgz = matrix(0, M[1], M[2])
  
  # Para cada nível de cinza é gerado uma região da imagem SAR, conforme os parâmetros informados
  for (i in 1:length(I)){
    # gera os dados SAR por região (determinada pelo nível de cinza da imagem) 
    R = ga0(M,N,A[i],G[i],1)
	
	# Aplica os dados SAR apenas sobre a região determinada pelo nível de cinza
    imgaux = ((img==I[i])*R)
	
	# Monta a imagem SAR resultante com os fragmentos das regiões geradas
    imgz = imgz + imgaux
  }
  
  return(imgz)
}


# CARREGA A IMAGEM BINÁRIA
x <- read.pnm("img_Real.pbm")
#plot(x)


# TRANSFORMA A IMAGEM EM UMA MATRIX
imagem <- getChannels(x)

# Para mostrar a imagem
#image(imagem, axes = FALSE, col = grey(seq(0, 1, length = 256)))


# INICIALIZAÇÃO DOS PARÂMETROS
mi = 20              # média da distribuição
alfa = c(-1.4,-5,-8) # (-1.4,-5,-8) parâmetro alfa
L = 1                # (1,5,8) número de looks
gama <- NULL


#Cálculo do parâmetro gama a partir da média da distribuição e do valor do parâmetro alfa
for(i in 1:length(alfa)){
   gama[i] <- L*((mi*gamma(-alfa[i])*gamma(L))/(gamma(-alfa[i]-0.5)*gamma(L+0.5)))^2
}

# Para o caso do parâmetro gama ser informado e não calculado
#gama = c(0.4, 20, 20)

# Gera a imagem utilizando o método direto
imagem_ga0_direto = imgz_direta(imagem,L,alfa,gama)
image(imagem_ga0_direto, axes = FALSE, col = grey(seq(0, 1, length = 256)))

# Gera a imagem utilizando o método indireto
imagem_ga0_indireto = imgz_indireta(imagem,L,alfa,gama)
image(imagem_ga0_indireto, axes = FALSE, col = grey(seq(0, 1, length = 256)))



