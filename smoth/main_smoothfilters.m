%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                               MAIN                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [noise,smooth] = main_smoothfilters(imagem,ruido,paramRuido,dominioFiltro, tipoSmoothing, paramFiltro)

noise = applyRuido(imagem,ruido,paramRuido);
switch dominioFiltro
    case 'spatial' 
        smooth = filtroSpatial(noise,tipoSmoothing,paramFiltro);
    case 'frequency'
        smooth = filtroFrequency(imagem,noise,tipoSmoothing,paramFiltro);
    otherwise
        error(strcat(('Domínio de filtro inválido. Opções: '),('spatial, frequency')));
end
compare_dft(imagem,noise, smooth)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                Função para aplicar ruido à imagem                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [noise] = applyRuido(imagem,ruido,paramRuido)

switch ruido
    case 'salt & pepper'
        rndmxpcnt=rand(size(imagem));
        worb=rand(size(imagem));            
        noise=imagem;                       %alloc
        for i=1:size(imagem)
            for j=1:size(imagem)
                if(rndmxpcnt(i,j)>= 1-paramRuido)  
                     % add noise if threshold (1-paramRuido) > randmvalue
                    if(worb(i,j)>0.5)       
                        noise(i,j)= 255;    % 50% white
                    else
                        noise(i,j)= 0;      % 50% black
                    end
                end
            end
        end
    case 'gaussian'
        gauss=randn(size(imagem)).*(paramRuido*255);
        noise=uint8(mat2gray(double(imagem)+gauss).*255);
    otherwise
        error(strcat('Ruído inválido. Opções: '),('salt & pepper, gaussian'));
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         Função para aplicar smoothing com filtro espacial           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[smooth] = filtroSpatial(noise,tipoSmoothing,paramFiltro)

    switch tipoSmoothing
            case 'average'                          
                h = ones(paramFiltro(1))./(paramFiltro(1)^2);       
                smooth = filterCorrelation(noise,h);
            case 'gaussian'
                filter= gaussKern(paramFiltro);
                smooth = filterCorrelation(noise,filter);            
            case 'median'
                    imgSz=size(noise);ks=paramFiltro(1);
                    padthicc=ceil((ks-1)/2);
                    p = padarray(noise,[padthicc padthicc],0,'both'); %img w/ padding
    
                for i=1:size(noise)
                    for j=1:size(noise)
                        filter=p(i:i+(ks-1),j:j+(ks-1));     %get neighbors
                        smooth(i,j)=median(filter,'all');    % matrix median
                    end
                end
                
                
        otherwise
                error(strcat(('Tipo de smoothing inválido. Opções: '),('butterworth, gaussian')));
    end   



end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Função para aplicar smoothing com filtro no domínio das frequências %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[smooth] = filtroFrequency(imagem,noise,tipoSmoothing,paramFiltro)
  

    switch tipoSmoothing
        case 'gaussian'     
            % criar o filtro
            h= gaussKern(paramFiltro);
        case 'butterworth'
            h = butterworth(paramFiltro(1),paramFiltro(2),paramFiltro(3));
           
        otherwise
            error(strcat(('Tipo de smoothing inválido. Opções: '),('average, gaussian, median')));      
    end   
    
    
    hh = padarray(h,[256 256],0,'both');
    [f, etcf] = dft(noise, size(noise));
    g = hh .* f;
    
   [trr, tr2] = dft(imagem, size(imagem));
    
    smooth = idft(g);
    
    compare_snr(imagem,noise,smooth);
    compare_spectres(imagem,noise,smooth,etcf,g,tr2);
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Função para calcular o filtro Butterworth               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                Função para aplicar DFT numa imagem.                 %%%
%%%   Retorna a imagem com dft e uma imagem já pronta para vizualizar   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [imgDFTCentrada,resultado] = dft(imagem, paramFiltro)
    size = paramFiltro(1)./2; %metade do tamanho do kernel
    
    padding = padarray(imagem,[size size],0,'both');
    imgComDFT = (fft2(padding)); %aplicar DFT
    imgDFTCentrada = fftshift(imgComDFT);
    resultado = mat2gray(log(abs(imgDFTCentrada)+1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%           Função para aplicar a inversa DFT numa imagem             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resultado = idft(imagem)
    imgsemDFT = ifft2(imagem); %aplicar DFT
   
    for i=1:size(imagem)
        for j=1:size(imagem)
            imreal(i,j)=imgsemDFT(i,j)*((-1)^(i+j));
        end
    end
    
    
 
   resultado=imreal(size(imreal)/4 +1:size(imreal)*3/4, size(imreal)/4 +1:size(imreal)*3/4);

   resultado =mat2gray(real(resultado));
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Função para comparação da DFT da imagem                 %%%
%%%                 original, com ruido e com o filtro                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = compare_dft(imagem,noise,smooth)
    figure('Name','Comparação do DFT entre a imagem original, com ruido e a imagem com o filtro','NumberTitle','off');
    subplot(3,2,1),imshow(imagem);
    [A,B] = dft(imagem,512);
    subplot(3,2,2),imshow(B);
    title('Imagem original')
    [C,D] = dft(noise,512);
    subplot(3,2,3),imshow(noise);
    subplot(3,2,4),imshow(D);
    title('Imagem com ruído')
    subplot(3,2,5),imshow(smooth);
    [F,G]= dft(smooth,512);
    subplot(3,2,6),imshow(G);
    title('Imagem com filtro')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Função para comparação do espectro da imagem            %%%
%%%                 original, com ruido e com o filtro                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = compare_spectres(imagem,noise,smooth,etcf,g,tr2)
    figure('Name','Comparação do espectro entre a imagem original, com ruido e a imagem com o filtro','NumberTitle','off');
    subplot(3,2,1);imshow(imagem);
    subplot(3,2,2);plot(abs(tr2));
    title('Imagem original')
    subplot(3,2,3);imshow(noise);
    subplot(3,2,4);plot(etcf);
    title('Imagem com ruído')
    subplot(3,2,5);imshow(smooth);
    subplot(3,2,6);plot(mat2gray(log(abs(g)+1)));
    title('Imagem com filtro')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Função para calcular o snr de uma imagem                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function snr =  snrr(img,noise)
if (size(img)~= size(noise)) 
    throw error;
end
sr = imdivide(img,noise);
snr = 10 .* log10(im2double(sr));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%               Função para comparação do ruido da imagem             %%%
%%%                       com ruido e com o filtro                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[] = compare_snr(imagem,noise,smooth)
    figure('Name','Comparação do ruido entre a imagem com ruido e a imagem com o filtro','NumberTitle','off');
    subplot(1,2,1);
    imshow(snrr(im2double(imagem),im2double(noise)));
    title('Imagem com ruido')
    subplot(1,2,2);
    imshow(snrr(im2double(imagem),smooth));
    title('Imagem com filtro')
end

