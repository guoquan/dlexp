function [ f ] = getSigmoid
f.f = @sigmoid;
f.d = @dsigmoid;
end

function y = sigmoid(x,~)
y = 1 ./ (1 + exp(-x));
end

function d = dsigmoid(~, y, ~) 
d = y .* (1 - y);
end
