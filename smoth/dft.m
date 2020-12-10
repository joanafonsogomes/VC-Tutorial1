function [imgDFTCentrada,resultado] = dft(imagem, paramFiltro)
    size = paramFiltro(1)./2; %metade do tamanho do kernel
    
    padding = padarray(imagem,[size size],0,'both');
    imshow(padding)
    imreal = (fft2(padding)); %aplicar DFT
    nopad=imreal(size(imreal)/4 +1:size(imreal)*3/4, size(imreal)/4 +1:size(imreal)*3/4);

    imgDFTCentrada = fftshift(nopad);
    resultado = mat2gray(log(abs(imgDFTCentrada)+1));
end
