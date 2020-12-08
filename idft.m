function resultado = idft(imagem, paramFiltro)
    imgsemDFT = ifft2(imagem); %aplicar DFT
   
    
    imreal = real(imgsemDFT);
    for i=1:size(imagem)
        for j=1:size(imagem)
            imreal(i,j)=imgsemDFT(i,j)*((-1)^(i+j));
        end
    end
    
   resultado=imreal(size(imreal)/4 +1:size(imreal)*3/4, size(imreal)/4 +1:size(imreal)*3/4);

   resultado =mat2gray(real(resultado));
    
end