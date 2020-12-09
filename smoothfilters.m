%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%                 Inputs do utilizador              %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt = 'Caminho para a imagem: ';
ficheiro = input(prompt,'s');
original =  split(ficheiro,'.');
original = string(original(1));
imread(ficheiro);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt = '\n\nTipo de ruído a aplicar ( gaussian | salt & pepper ): ';
ruido = input(prompt,'s');
if strcmp(ruido,'gaussian')
    prompt = 'Média: ';
    paramRuido(1) = input(prompt);
    prompt = 'Variância: ';
    paramRuido(2) = input(prompt);
else
    if strcmp(ruido,'salt & pepper')
        prompt = 'Densidade: ';
        paramRuido = input(prompt);
    else
        error('Tipo de ruído inválido.');
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt = '\n\nDominio do filtro ( spatial | frequency ): ';
dominioFiltro = input(prompt,'s');

switch dominioFiltro
    case 'spatial'
        prompt = 'Tipo ( average | gaussian | median ): ';
        tipoSmoothing = input(prompt,'s');
        switch tipoSmoothing
            case 'average'
                prompt = 'Hsize: ';
                paramFiltro(1) = input(prompt);
            case 'gaussian'
                prompt = 'Hsize: ';
                paramFiltro(1) = input(prompt);
                prompt = 'Sigma: ';
                paramFiltro(2) = input(prompt);
            case 'median'
                prompt = 'Hsize(MxN)\nM: ';
                paramFiltro(1) = input(prompt);
                prompt = 'N: ';
                paramFiltro(2) = input(prompt);
            otherwise
                error('Tipo de Smoothing inválido.');
        end
    case 'frequency'
        prompt = 'Frequência ( gaussian | butterworth ): ';
        tipoSmoothing = input(prompt,'s');
        switch tipoSmoothing
            case 'gaussian'
                prompt = 'Hsize: ';
                paramFiltro(1) = input(prompt);
                prompt = 'Sigma: ';
                paramFiltro(2) = input(prompt);
            case 'butterworth'
                prompt = 'Hsize: ';
                paramFiltro(1) = input(prompt);
                prompt = 'n: ';
                paramFiltro(2) = input(prompt);
                prompt = 'D0: ';
                paramFiltro(3) = input(prompt);
            otherwise
                error('Tipo de smoothing inválido.');
        end
    otherwise 
        error('Tipo de filtro inválido.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Leitura da imagem e aplicação do respetivo noise e filtro      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imagem = rgb2gray(imread(ficheiro));
imwrite(imagem, strcat(original,'_gray','.png'));
[noise,smooth] = main_smoothfilters(imagem,ruido,paramRuido,dominioFiltro, tipoSmoothing, paramFiltro);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%   Escrita da Imagem com Ruído    %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(strcmp(ruido,'salt & pepper'))
    output = strcat(original,'_',ruido,'_',num2str(paramRuido(1)),'.png');
else
    output = strcat(original,'_',ruido,'_',num2str(paramRuido(1)),'_',num2str(paramRuido(2)),'_','.png');
end

imwrite(noise,output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Escrita da imagem com o filtro da frequencia%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output = 'error.png';
switch dominioFiltro
    case 'spatial'
        switch tipoSmoothing
            case 'average'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'.png');
            case 'gaussian'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'_',num2str(paramFiltro(2)),'.png');
            case 'median'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'_',num2str(paramFiltro(2)),'.png');
        end
    case 'frequency'
        switch tipoSmoothing
            case 'gaussian'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'_',num2str(paramFiltro(2)),'.png');
            case 'butterworth'
                output = strcat(original,'_',dominioFiltro,'_',tipoSmoothing,'_',num2str(paramFiltro(1)),'_',num2str(paramFiltro(2)),'_',num2str(paramFiltro(3)),'.png');
        end
        
end
  
imwrite(smooth,output);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
