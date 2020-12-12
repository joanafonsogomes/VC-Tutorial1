prompt = 'Caminho para a imagem: ';
ficheiro = input(prompt,'s');
imagem = rgb2gray(imread(ficheiro));
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

output = strcat(original,'_edge_canny_',num2str(kernel),'_', num2str(sigma),'_','.png');
imwrite(before_nomax,output);
 
output = strcat(original,'_edge_canny_nomax_',num2str(kernel),'_', num2str(sigma),'_','.png');
imwrite(after_nomax,output);


output = strcat(original,'_edge_canny_hysteresis_',num2str(kernel),'_', num2str(sigma),'_','.png');
imwrite(after_hysteresis,output);

    