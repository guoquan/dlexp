function [ f ] = getRectifier
f.f = @rectifier;
f.d = @rectifier_d;
end

function y = rectifier(x,~)
    y = zeros(size(x));
    y(x>0) = x(x>0);
end

function d = rectifier_d(x, ~, ~)
    d = zeros(size(x));
    d(x>0)=1;
end
