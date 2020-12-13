function gaussian = gaussian_smoothing(imagem,size,sigma)

g = fspecial('gaussian',size,sigma);   
gaussian = imfilter(imagem,g);

end

