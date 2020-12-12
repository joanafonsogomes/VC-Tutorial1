function [strongedges,weakedges] = double_threshold(thinned_image,thresholdmin,thresholdmax)
    
    weakedges = zeros(size(thinned_image));
    strongedges = zeros(size(thinned_image));
   
  
    weakedges(thinned_image>=thresholdmin)=0.5;
    strongedges(thinned_image>=thresholdmax)=1;

end

