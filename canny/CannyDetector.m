prompt = 'Caminho para a imagem: ';
ficheiro = input(prompt,'s');
imagem = imread(ficheiro);
original = split(ficheiro,'.');
original = string(original(1));

prompt = '\nTamanho do Kernel: ';
kernel = input(prompt);
prompt = '\nVariância: ';
sigma = input(prompt);
thresholdmin = 20;
thresholdmax = 70;


[before_nomax,after_nomax,after_hysteresis] = ...
    main_CannyDetector(imagem,kernel,sigma,thresholdmin,thresholdmax);

output = strcat(original,'_edge_canny_',num2str(kernel),'_', num2str(sigma),'.png');
imwrite(before_nomax,output);
 
output = strcat(original,'_edge_canny_nomax_',num2str(kernel),'_', num2str(sigma),'.png');
imwrite(after_nomax,output);


%Comparação
%canny = edge(imagem,'canny');
prewitt = edge(imagem,'Prewitt');
sobel = edge(imagem,'Prewitt');
laplace = edge(imagem,'log');

    figure('Name','Comparação');
    %subplot(2,2,3),imshow(canny);
    subplot(2,2,1),imshow(after_hysteresis);
    title('Canny')
    subplot(2,2,2),imshow(prewitt);
    title('Prewitt');
    subplot(2,2,3),imshow(sobel);
    title('Sobel')
    subplot(2,2,4),imshow(laplace);
    title('Laplacian of Gaussian')

output = strcat(original,'_Matlabedge_’canny’_',num2str(kernel),'_', num2str(sigma),'.png');
%imwrite(canny,output);
output = strcat(original,'_Matlabedge_’sobel’_',num2str(kernel),'_', num2str(sigma),'.png');
imwrite(prewitt,output);
output = strcat(original,'_Matlabedge_’prewit’_',num2str(kernel),'_', num2str(sigma),'.png');
imwrite(sobel,output);
output = strcat(original,'_Matlabedge_’lapacian’_',num2str(kernel),'_', num2str(sigma),'.png');
imwrite(laplace,output);

    