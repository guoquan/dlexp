function [ f ] = getQuadratifier
f.f = @q;
f.d = @dq;
end

function y = q(x,~)
    y = zeros(size(x));
    y(x>0) = x(x>0).^2;
end

function d = dq(x, ~, ~)
    d = zeros(size(x));
    d(x>0) = 2*x(x>0);
end
