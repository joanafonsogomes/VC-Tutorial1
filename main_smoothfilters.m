function [noise,smooth] = main_smoothfilters(imagem,ruido,paramRuido,dominioFiltro, tipoSmoothing, paramFiltro)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

switch dominioFiltro
    case 'spatial' 
        
        switch tipoSmoothing
            case 'average'
                h = fspecial('average',paramFiltro(1));
                smooth = imfilter(noise,h);
            case 'gaussian'
                h = fspecial('gaussian',paramFiltro(1),paramFiltro(2));
                smooth = imfilter(noise,h);            
            case 'median'
                smooth = medfilt2(noise,[paramFiltro(1) paramFiltro(1)]);
            otherwise
            error(strcat(('Tipo de smoothing inválido. Opções: '),('average, gaussian, median')));
        end   
        
     case 'frequency'
         
         switch tipoSmoothing
             case 'butterworth'
                 h = butterworthFilter(paramFiltro(1),paramFiltro(2),paramFiltro(3));
             case 'gaussian'
                 h = fspecial('gaussian',paramFiltro(1),paramFiltro(2));
          otherwise
            error(strcat(('Tipo de smoothing inválido. Opções: '),('butterworth, gaussian')));
         end
otherwise
   error(strcat(('Domínio de filtro inválidpo. Opções: '),('spatial, frequency')));
end
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


