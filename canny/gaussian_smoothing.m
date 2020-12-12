function new_img = gaussian_smoothing(imagem,size,sigma)

g = fspecial('gaussian',size,sigma);   
new_img = imfilter(imagem,g);

end

