original = 'baboon';
ficheiro = 'baboon.png';

ruido = 'gaussian';
paramRuido = [0,0.01];

dominioFiltro = 'frequency';
tipoSmoothing = 'butterworth';
paramFiltro = [10,4,10];

%%%%%%%%%%%%%%%%%%%%%%%%5

imagem = rgb2gray(imread(ficheiro));
imagem = im2double(imagem);%/255;
[noise,smooth] = main_smoothfilters(imagem,ruido,paramRuido,dominioFiltro, tipoSmoothing, paramFiltro);

output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro),'.png');
imwrite(smooth,output);

output = strcat(original,'_',ruido,'_',num2str(paramFiltro),'_','.png');
imwrite(noise,output);




