function snr =  snrr(img,noise)
if (size(img)~= size(noise)) 
    throw error;
end
sr = imdivide(img,noise);
snr = 10 .* log10(im2double(sr));

end