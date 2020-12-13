function kernel = gaussKern(paramFiltro)
sz=paramFiltro(1);
                filter=zeros(sz);
                for i=1:paramFiltro(1)
                    for j=1:paramFiltro(1)
                        rcx=(0.5+i-1-(sz/2))^2;
                        rcy=(0.5+j-1-(sz/2))^2;
                        filter(i,j)=exp(-((((rcx+rcy)/(2*(paramFiltro(2)^2))))));
                    end
                end
                sm=sum(filter,'all');
                kernel=filter./sm;
 
end