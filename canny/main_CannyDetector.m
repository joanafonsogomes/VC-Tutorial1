function canny = main_CannyDetector(imagem,kernel,sigma,thresholdmin,thresholdmax)

gaussian = gaussian_smoothing(imagem,kernel,sigma);

[magnitude,direcao] = gradient(imagem);

improved_image = nonmax(direcao,magnitude);

[strongedges,weakedges] = double_threshold(improved_image,thresholdmin,thresholdmax);

edgemap = hysteresis_thresholding2(strongedges,weakedges);


figure;
imshow(strongedges);
figure;
imshow(weakedges);
figure;
imshow(edgemap);
end

