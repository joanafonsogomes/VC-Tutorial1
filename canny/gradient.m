function [magnitude,direcao] = gradient(imagem)

z_h = [-1 -2 -1 ; 0 0 0; 1 2 1];
z_v = [-1 0 1; -2 0 2; -1 0 1];


img_filth = filterCorrelation(imagem,z_h);
img_filtv = filterCorrelation(imagem,z_v);

direcao = atan2d(double(img_filth),double(img_filtv));

magnitude = uint8(sqrt((double(img_filth)).^2 + (double(img_filtv)).^2));

end

