function [ f ] = getSoftplus
f.f = @st;
f.d = @dst;
end
function y = st(x,~)
    y = log(1+exp(x));
end
function d = dst(x,~,~)
d = 1 ./ (1 + exp(-x));
end