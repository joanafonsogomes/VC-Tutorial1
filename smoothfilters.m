original = 'baboon';
ficheiro = 'baboon.png';

ruido = 'salt & pepper';
paramRuido = [0.2,0.02];
%Para salt & pepper usar o primeiro valor
%para gaussian 1º valor para a média e o 2º para a variância

dominioFiltro = 'frequency';
tipoSmoothing = 'butterworth';
paramFiltro = [512,2,10];
%Para dominioFiltro spacial:
%average - Usado apenas o primeiro valores para definir o tamanho da matriz
%gaussian - Usado o primeiro valor para o tamanho da matriz, e o segundo valor para o sigma
%median - Usado o primeiro valor para o numero de colunas da matriz e o segundo para as linhas
%Para frequencia:
%gaussian - Usado o primeiro valor para o tamanho da matriz, e o segundo valor para o sigma
%butterworth - Primeiro valor para o tamanho , segundo para o n e o 3º para o D0


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
        switch tipoSmoothing
            case 'gaussian'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'_',num2str(paramFiltro(2)),'.png');
            case 'butterworth'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'_',num2str(paramFiltro(2)),'_',num2str(paramFiltro(3)),'.png');
        end
        
end
  
imwrite(smooth,output);

if(strcmp(ruido,'salt & pepper'))
    output = strcat(original,'_',ruido,'_',num2str(paramRuido(1)),'.png');
else
    output = strcat(original,'_',ruido,'_',num2str(paramRuido(1)),'_',num2str(paramRuido(2)),'_','.png');
end

imwrite(noise,output);




