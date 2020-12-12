function edgemap = hysteresis_thresholding(strongedges,weakedges)

sizee = size(strongedges);
edgemap = strongedges;


for i = 2 : sizee-1
    for j = 2 : sizee-1
        if(weakedges(i,j) == 0.5)
            if(strongedges(i,j)==1 || strongedges(i+1,j)==1 || ...
                    strongedges(i-1,j)==1 || strongedges(i,j+1)==1 || ...
                    strongedges(i,j-1)==1 || strongedges(i-1, j-1)==1 || ...
                    strongedges(i-1, j+1)==1 || strongedges(i+1, j+1)==1 || ...
                    strongedges(i+1, j-1)==1)
                edgemap(i,j)=1;
            else
                edgemap(i,j)=0;
            end
        end
    end
end





end

