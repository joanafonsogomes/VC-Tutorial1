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
figure

end

%{
         switch tipoSmoothing
             case 'butterworth'
                 h = butterworthFilter(paramFiltro(1),paramFiltro(2),paramFiltro(3));
             case 'gaussian'
                 h = fspecial('gaussian',paramFiltro(1),paramFiltro(2));
          otherwise
            error(strcat(('Tipo de smoothing inválido. Opções: '),('butterworth, gaussian')));
         end
         %}
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

%{
function[] = dft(imagem)


end

function[] = compare_dft(imagem)


end
%}

function[smooth] = filtroFrequency(imagem,noise,tipoSmoothing,paramFiltro)
  

    switch tipoSmoothing
        case 'gaussian'     
            smooth = fspecial('gaussian',paramFiltro(1),paramFiltro(2));
        case 'butterworth'
            smooth = butterworthFilter(paramFiltro(1),paramFiltro(2),paramFiltro(3));
        otherwise
            error(strcat(('Tipo de smoothing inválido. Opções: '),('average, gaussian, median')));
    end   

end

