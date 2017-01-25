function [ linear ] = getLinear
linear.f = @(x,~) x;
linear.d = @(x,~,~) ones(size(x));
end
