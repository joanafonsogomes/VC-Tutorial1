function h = butterworth(size,n,d0)
    h = zeros(size, size);
    m = (size + 1)/2;
    t = 0;
    for u = 1:size
        for v = 1:size
            x = u - m;
            y = v - m;
            d = sqrt(x.^2 + y.^2);
            a = 1./(1 + (d / d0).^(2 .* n));
            h(u, v) = a;
            t = t + a;
        end
    end
    h = h ./ t;
end