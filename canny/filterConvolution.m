function resultImg = filterConvolution(img,kernel)
    krnSz=size(kernel); %sizes
    convReadyKernel = zeros(krnSz);
    for i=1:krnSz
        for j=1:krnSz               %   rotate 180º 
            convReadyKernel(i,j)= kernel((krnSz(1)+1)-j,(krnSz(1)+1)-i);    
        end
    end
    resultImg= filterCorrelation(img,convReadyKernel); %correlate 180º convolution filter;
    
end