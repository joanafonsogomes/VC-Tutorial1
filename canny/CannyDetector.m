imagem = imread('lena.png');
kernel = 20;
sigma = 5;


canny = main_CannyDetector(imagem,kernel,sigma);