function [ f ] = getSoftThres
f.f = @st;
f.d = @dst;
end
function y = st(x,~)
    alpha = 0.1;
    beta = 1;
    y = beta * (x - sign(x) * alpha);
    y(abs(x) <= alpha) = 0;
end
function d = dst(x,~,~)
    alpha = 0.1;
    beta = 1;
    d = zeros(size(x));
    d(abs(x) > alpha) = beta;
end