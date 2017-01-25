function d = rectifier_d(a)
    d = zeros(size(a));
    d(a>0)=1;
end
