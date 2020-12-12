function [before_nomax,after_nomax,after_hysteresis] = main_CannyDetector(imagem,kernel,sigma,thresholdmin,thresholdmax)

gaussian = gaussian_smoothing(imagem,kernel,sigma);

[magnitude,direcao] = gradient(gaussian);

before_nomax = magnitude;

improved_image = nonmax(direcao,magnitude);

after_nomax = improved_image;

[strongedges,weakedges] = double_threshold(improved_image,thresholdmin,thresholdmax);

edgemap = hysteresis_thresholding(strongedges,weakedges);

after_hysteresis = edgemap;
%{
figure;
imshow(strongedges);
figure;
imshow(weakedges);
figure;
imshow(edgemap);
%}
end

