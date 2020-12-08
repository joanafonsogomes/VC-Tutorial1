function [noise,smooth] = main_smoothfilters(imagem,ruido,paramRuido,dominioFiltro, tipoSmoothing, paramFiltro)

noise = applyRuido(imagem,ruido,paramRuido);
%smooth = filtroSpatial(noise,tipoSmoothing,paramFiltro);
switch dominioFiltro
    case 'spatial' 
        smooth = filtroSpatial(noise,tipoSmoothing,paramFiltro);
    case 'frequency'
        smooth = filtroFrequency(imagem,noise,tipoSmoothing,paramFiltro);
    otherwise
        error(strcat(('Domínio de filtro inválido. Opções: '),('spatial, frequency')));
end
compare_dft(imagem,noise)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%aplicar ruido a imagem
function [noise] = applyRuido(imagem,ruido,paramRuido)

switch ruido
    case 'salt & pepper'
        noise = imnoise(imagem,ruido,paramRuido(1));
    
    case 'gaussian'
        noise = imnoise(imagem,ruido,paramRuido(1),paramRuido(2));
     
    otherwise
        error(strcat('Ruído inválido. Opções: '),('salt & pepper, gaussian'));
 
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fazer smothing com filtro espacial
function[smooth] = filtroSpatial(noise,tipoSmoothing,paramFiltro)

    switch tipoSmoothing
            case 'average'
                h = fspecial('average',paramFiltro(1));
                smooth = imfilter(noise,h);
            case 'gaussian'
                h = fspecial('gaussian',paramFiltro(1),paramFiltro(2));
                smooth = imfilter(noise,h);            
            case 'median'
                smooth = medfilt2(noise,[paramFiltro(1) paramFiltro(2)]);
        otherwise
                error(strcat(('Tipo de smoothing inválido. Opções: '),('butterworth, gaussian')));
    end   



end

function resultado = idft(imagem, paramFiltro)
    imgsemDFT = ifft2(imagem); %aplicar DFT
    
    
    imreal = abs(imgsemDFT);
    
    for i=1:(size(imagem)/2)
        for j=1:(size(imagem)/2)
            resultado(i,j)= imreal(i,j);
        end
    end
    
    resultado = uint8(resultado);
    
end

function [imgDFTCentrada,resultado] = dft(imagem, paramFiltro)
    size = paramFiltro(1)./2; %metade do tamanho do kernel
    padding = padarray(imagem,[size size],0,'both');
    imgComDFT = abs(fft2(padding)); %aplicar DFT
    imgDFTCentrada = fftshift(imgComDFT);
    resultado = mat2gray(imgDFTCentrada)*255;
end

function[] = compare_dft(imagem,noise)
    figure;
    subplot(3,2,1),imshow(imagem);
    [A,B] = dft(imagem,512);
    subplot(3,2,2),imshow(B);
    [C,D] = dft(noise,512);
    subplot(3,2,3),imshow(noise);
    subplot(3,2,4),imshow(D);
    subplot(3,2,5),imshow(imagem);
    subplot(3,2,6),imshow(idft(A,512));
end

function[smooth] = filtroFrequency(imagem,noise,tipoSmoothing,paramFiltro)
  

    switch tipoSmoothing
        case 'gaussian'     
            % criar o filtro
            h = fspecial('gaussian',paramFiltro(1),paramFiltro(2));
        case 'butterworth'
            h = butterworth(paramFiltro(1),paramFiltro(2),paramFiltro(3));
        otherwise
            error(strcat(('Tipo de smoothing inválido. Opções: '),('average, gaussian, median')));      
    end   
    
    [h, etc] = dft(h, 2*size(imagem)-size(h));
    [f, etc] = dft(imagem, size(imagem));
    g = h .* f;
    figure; imshow(mat2gray(g)*255);
    smooth = idft(g,size(imagem));
end

function h = butterworth(size,n,d0)
    h = zeros(size, size);
    m = (size + 1)/2;
    t = 0;
    for u = 1:size
        for v = 1:size
            x = u - m;
            y = v - m;
            d = sqrt(x.^2 + y.^2);
            a = 1./(1 + (d / d0).^(2 .* n));
            h(u, v) = a;
            t = t + a;
        end
    end
    h = h ./ t;
end
