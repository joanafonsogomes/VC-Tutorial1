%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                  Test File                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


img(:,:)=10;
krn=ones(3)./9;


imagem = rgb2gray(imread('lena.jpg'));

ruido='salt & pepper';
paramRuido=0.2;
%{
ruido='gaussian';
paramRuido=20;
dominioFiltro='spatial';


tipoSmoothing='gaussian';
paramFiltro=[3,1];
%}
tipoSmoothing='median';
paramFiltro=[5,5];
[noise,smooth] = main_smoothfilters(imagem,ruido,paramRuido,dominioFiltro, tipoSmoothing, paramFiltro);
imshow(noise);
