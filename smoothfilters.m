original = 'baboon';
ficheiro = 'baboon.png';

ruido = 'salt & pepper';
paramRuido = [0.02,0.02];
%Para salt & pepper usar o primeiro valor
%para gaussian 1º valor para a média e o 2º para a variância

dominioFiltro = 'spatial';
tipoSmoothing = 'median';
paramFiltro = [100,100,0];
%Para dominioFiltro spacial:
%average - Usado apenas o primeiro valores para definir o tamanho da matriz
%gaussian - Usado o primeiro valor para o tamanho da matriz, e o segundo valor para o sigma
%median - Usado o primeiro valor para o numero de colunas da matriz e o segundo para as linhas
%Para frequencia:



%%%%%%%%%%%%%%%%%%%%%%%%

imagem = rgb2gray(imread(ficheiro));
%imagem = double(imagem);%/255;
[noise,smooth] = main_smoothfilters(imagem,ruido,paramRuido,dominioFiltro, tipoSmoothing, paramFiltro);

output = 'error';
switch dominioFiltro
    case 'spatial'
        switch tipoSmoothing
            case 'average'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'.png');
            case 'gaussian'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'_',num2str(paramFiltro(2)),'.png');
            case 'median'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'_',num2str(paramFiltro(2)),'.png');
        end
    case 'frequency'
end
  
imwrite(smooth,output);

if(strcmp(ruido,'salt & pepper'))
    output = strcat(original,'_',ruido,'_',num2str(paramRuido(1)),'.png');
else
    output = strcat(original,'_',ruido,'_',num2str(paramRuido(1)),'_',num2str(paramRuido(2)),'_','.png');
end

imwrite(noise,output);




