function edgemap = hysteresis_thresholding(strongedges,weakedges)

sizee = size(strongedges);

weakedges_p = padarray(weakedges,[1 1],0,'both');
strongedges_p = padarray(strongedges,[1 1],0,'both');
edgemap = weakedges_p;


for i = 2 : sizee
    for j = 2 : sizee
        if(strongedges_p(i,j)==2 || strongedges_p(i+1,j)==2 || ...
                strongedges_p(i-1,j)==2 || strongedges_p(i,j+1)==2 || ...
                strongedges_p(i,j-1)==2 || strongedges_p(i-1, j-1)==2 || ...
                strongedges_p(i-1, j+1)==2 || strongedges_p(i+1, j+1)==2 || ...
                strongedges_p(i+1, j-1)==2)
            edgemap(i,j)=1;
        else
            edgemap(i,j)=0;
        end
    end
end



end

