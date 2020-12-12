function resultImg = filterCorrelation(img,kernel)
    imgSz=size(img);krnSz=size(kernel); %sizes
    
    img=double(img);    %make it multipliable
    
    padthicc=ceil((krnSz-1)/2);
    
    p = padarray(img,padthicc,0,'both'); %img w/ padding
    
    resultImg = zeros(imgSz); %alloc
    
    for i = 1:imgSz
        for j = 1:imgSz
            imkrn=p(i:i+(krnSz-1),j:j+(krnSz-1));       %fragment to be multiplied
            resultImg(i,j)= sum(kernel.*imkrn,'all');   %correlation (sumprod)   
        end
    end
    resultImg=uint8(resultImg); %restore type
end