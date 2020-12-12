function improved_image = nonmax(direcao,magnitude)
    [h,w] = size(direcao);
    improved_image = zeros(h+2,w+2);
    [h,w]=size(direcao);
    
    for i=2:h+1
        for j=2:w+1
            improved_image(i,j)=magnitude(i-1,j-1);
        end
    end

    for i=2:h-1 
        for j=2:w-1         
            if ((direcao(i,j)>=-22.5 && direcao(i,j)<=22.5) || direcao(i,j)<-157.5 || direcao(i,j)>157.5 )
                %deteta a direção -
                if (magnitude(i,j) >= magnitude(i,j+1)) && (magnitude(i,j) >= magnitude(i,j-1))
                    improved_image(i,j)= magnitude(i,j);
                else
                    improved_image(i,j)=0;
                end
            elseif ((direcao(i,j)>=22.5 && direcao(i,j)<=67.5) || (direcao(i,j)<-112.5 && direcao(i,j)>=-157.5))
                %deteta a direção /
                if (magnitude(i,j) >= magnitude(i+1,j+1)) && (magnitude(i,j) >= magnitude(i-1,j-1))
                    improved_image(i,j)= magnitude(i,j);
                else
                    improved_image(i,j)=0;
                end
            elseif (direcao(i,j)>=67.5 && direcao(i,j)<=112.5) || (direcao(i,j)<-67.5 && direcao(i,j)>=-112.5)
                %deteta a direção |
                if (magnitude(i,j) >= magnitude(i+1,j)) && (magnitude(i,j) >= magnitude(i-1,j))
                    improved_image(i,j)= magnitude(i,j);
                else
                    improved_image(i,j)=0;
                end
            elseif (direcao(i,j)>=112.5 && direcao(i,j)<=157.5) || (direcao(i,j)<-22.5 && direcao(i,j)>=-67.5)
                %deteta a direção \
                if (magnitude(i,j) >= magnitude(i+1,j-1)) && (magnitude(i,j) >= magnitude(i-1,j+1))
                    improved_image(i,j)= magnitude(i,j);
                else
                    improved_image(i,j)=0;
                end
            end
        end
    end
    
    improved_image = uint8(improved_image(2:h+1,2:w+1));
end

